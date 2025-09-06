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
                  "!And" = [
                    { "!HasFile" = ".radicle/native.yaml"; }
                    "!DefaultBranch"
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
      ];
    };

  testScript = ''
    start_all()

    seed.wait_for_unit("radicle-ci-broker.service")

    alice.succeed("rad auth --alias alice --stdin </dev/null")
    alice.copy_from_host("${radicleConfig "alice"}", "/root/.radicle/config.json")
    alice.succeed("rad node start")

    alice.succeed("mkdir /tmp/repo")
    alice.succeed("git -C /tmp/repo init")
    alice.succeed("mkdir /tmp/repo/.radicle")
    alice.succeed("echo 'shell: echo -n it works > /run/radicle-ci-broker/result' > /tmp/repo/.radicle/native.yaml")
    alice.succeed("git -C /tmp/repo add .")
    alice.succeed("git -C /tmp/repo commit -m init")

    alice.succeed("cd /tmp/repo && rad init --name repo --description \"\" --default-branch main --public")
    rid = alice.succeed("rad inspect --rid /tmp/repo").strip()
    seed.succeed(f"rad-system seed {rid}")
    assert seed.wait_until_succeeds("cat /run/radicle-ci-broker/result") == "it works"

    alice.succeed("echo 'shell: echo -n second commit > /run/radicle-ci-broker/result2' > /tmp/repo/.radicle/native.yaml")
    alice.succeed("git -C /tmp/repo add .")
    alice.succeed("git -C /tmp/repo commit -m 2")
    alice.succeed("git -C /tmp/repo push")
    assert seed.wait_until_succeeds("cat /run/radicle-ci-broker/result2") == "second commit"
  '';
}
