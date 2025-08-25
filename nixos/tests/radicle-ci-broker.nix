{ lib, pkgs, ... }:

let
  seed-nid = "z6Mkg52RcwDrPKRzzHaYgBkHH3Gi5p4694fvPstVE9HTyMB6";
  seed-ssh-keys = import ./ssh-keys.nix pkgs;

  radicleConfig =
    alias:
    pkgs.writeText "config.json" (
      builtins.toJSON {
        preferredSeeds = [ "${seed-nid}@seed:8776" ];
        node = { inherit alias; };
      }
    );
in

{
  name = "radicle-ci-broker";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.seed = {
    services.radicle = {
      enable = true;
      privateKeyFile = seed-ssh-keys.snakeOilEd25519PrivateKey;
      publicKey = seed-ssh-keys.snakeOilEd25519PublicKey;
      node.openFirewall = true;
      settings = {
        preferredSeeds = [ ];
        node.alias = "seed";
      };

      ci = {
        adapters.native.instances.native = { };
        broker = {
          enable = true;
          settings.triggers = [
            {
              adapter = "native";
              filters = [
                {
                  And = [
                    { HasFile = ".radicle/native.yaml"; }
                    "DefaultBranch"
                  ];
                }
              ];
            }
          ];
        };
      };
    };
  };

  nodes.alice =
    { pkgs, ... }:
    {
      environment.etc."gitconfig".text = ''
        [init]
          defaultBranch = main
        [user]
          email = root@alice
          name = alice
      '';

      environment.systemPackages = with pkgs; [
        gitMinimal
        radicle-node
        radicle-job
      ];
    };

  testScript = ''
    import json

    start_all()

    seed.wait_for_unit("radicle-ci-broker.service")

    alice.succeed("rad auth --alias alice --stdin </dev/null")
    alice.copy_from_host("${radicleConfig "alice"}", "/root/.radicle/config.json")
    alice.succeed("rad node start")

    alice_nid = alice.succeed("rad self --nid").strip()

    alice.succeed("mkdir /tmp/repo")
    alice.succeed("git -C /tmp/repo init")
    alice.succeed("mkdir /tmp/repo/.radicle")
    alice.succeed("echo 'shell: echo -n it works > /run/radicle-ci-broker/result' > /tmp/repo/.radicle/native.yaml")
    alice.succeed("git -C /tmp/repo add .")
    alice.succeed("git -C /tmp/repo commit -m init")

    alice.succeed("cd /tmp/repo && rad init --name repo --description \"\" --default-branch main --public")
    rid = alice.succeed("rad inspect --rid /tmp/repo").strip()

    def git_head():
      return alice.succeed("git -C /tmp/repo rev-parse HEAD").strip()

    def list_runs(oid):
      alice.succeed(f"rad sync {rid} -f")
      jobs = json.loads(alice.succeed(f"rad job --repository {rid} list"))["jobs"]
      return [
        {"node_id": run["node_id"], **node_run}
        for job in jobs if job["oid"] == oid
        for run in job["runs"] for node_run in run["runs"]
      ]

    def assert_run_succeeded(run):
      assert run["node_id"] == "${seed-nid}"
      assert run["status"] == {"Finished": "Succeeded"}

    assert list_runs(head := git_head()) == []
    seed.succeed(f"rad-system seed {rid}")
    assert seed.wait_until_succeeds("cat /run/radicle-ci-broker/result") == "it works"
    [run] = list_runs(head)
    assert_run_succeeded(run)

    alice.succeed("echo 'shell: echo -n second commit > /run/radicle-ci-broker/result2' > /tmp/repo/.radicle/native.yaml")
    alice.succeed("git -C /tmp/repo add .")
    alice.succeed("git -C /tmp/repo commit -m 2")
    assert list_runs(head := git_head()) == []
    alice.succeed("git -C /tmp/repo push")
    assert seed.wait_until_succeeds("cat /run/radicle-ci-broker/result2") == "second commit"
    [run] = list_runs(head)
    assert_run_succeeded(run)

    seed.succeed("rm /run/radicle-ci-broker/result2")
    seed.fail("cat /run/radicle-ci-broker/result2")
    seed.succeed(f"cibtool-system trigger --repo repo --node {alice_nid} --commit main")
    assert seed.wait_until_succeeds("cat /run/radicle-ci-broker/result2") == "second commit"
    [r1, r2] = list_runs(head)
    if r2 == run: r1, r2 = r2, r1
    assert r1 == run
    assert r2["run_id"] != run["run_id"]
    assert_run_succeeded(r2)
  '';
}
