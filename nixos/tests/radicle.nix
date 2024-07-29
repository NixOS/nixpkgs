# This test runs the radicle-node and radicle-httpd services on a seed host,
# and verifies that an alice peer can host a repository on the seed,
# and that a bob peer can send alice a patch via the seed.

{ pkgs, ... }:

let
  # The Node ID depends on nodes.seed.services.radicle.privateKeyFile
  seed-nid = "z6Mkg52RcwDrPKRzzHaYgBkHH3Gi5p4694fvPstVE9HTyMB6";
  seed-ssh-keys = import ./ssh-keys.nix pkgs;
  seed-tls-certs = import common/acme/server/snakeoil-certs.nix;

  commonHostConfig = { nodes, config, pkgs, ... }: {
    environment.systemPackages = [
      config.services.radicle.package
      pkgs.curl
      pkgs.gitMinimal
      pkgs.jq
    ];
    environment.etc."gitconfig".text = ''
      [init]
        defaultBranch = main
      [user]
        email = root@${config.networking.hostName}
        name = ${config.networking.hostName}
    '';
    networking = {
      extraHosts = ''
        ${nodes.seed.networking.primaryIPAddress} ${nodes.seed.services.radicle.httpd.nginx.serverName}
      '';
    };
    security.pki.certificateFiles = [
      seed-tls-certs.ca.cert
    ];
  };

  radicleConfig = { nodes, ... }: alias:
    pkgs.writeText "config.json" (builtins.toJSON {
      preferredSeeds = [
        "${seed-nid}@seed:${toString nodes.seed.services.radicle.node.listenPort}"
      ];
      node = {
        inherit alias;
        relay = "never";
        seedingPolicy = {
          default = "block";
        };
      };
    });
in

{
  name = "radicle";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      julm
      lorenzleutgeb
    ];
  };

  nodes = {
    seed = { pkgs, config, ... }: {
      imports = [ commonHostConfig ];

      services.radicle = {
        enable = true;
        privateKeyFile = seed-ssh-keys.snakeOilEd25519PrivateKey;
        publicKey = seed-ssh-keys.snakeOilEd25519PublicKey;
        node = {
          openFirewall = true;
        };
        httpd = {
          enable = true;
          nginx = {
            serverName = seed-tls-certs.domain;
            addSSL = true;
            sslCertificate = seed-tls-certs.${seed-tls-certs.domain}.cert;
            sslCertificateKey = seed-tls-certs.${seed-tls-certs.domain}.key;
          };
        };
        settings = {
          preferredSeeds = [];
          node = {
            relay = "always";
            seedingPolicy = {
              default = "allow";
              scope = "all";
            };
          };
        };
      };

      services.nginx = {
        enable = true;
      };

      networking.firewall.allowedTCPPorts = [ 443 ];
    };

    alice = {
      imports = [ commonHostConfig ];
    };

    bob = {
      imports = [ commonHostConfig ];
    };
  };

  testScript = { nodes, ... }@args: ''
    start_all()

    with subtest("seed can run radicle-node"):
      # The threshold and/or hardening may have to be changed with new features/checks
      print(seed.succeed("systemd-analyze security radicle-node.service --threshold=10 --no-pager"))
      seed.wait_for_unit("radicle-node.service")
      seed.wait_for_open_port(${toString nodes.seed.services.radicle.node.listenPort})

    with subtest("seed can run radicle-httpd"):
      # The threshold and/or hardening may have to be changed with new features/checks
      print(seed.succeed("systemd-analyze security radicle-httpd.service --threshold=10 --no-pager"))
      seed.wait_for_unit("radicle-httpd.service")
      seed.wait_for_open_port(${toString nodes.seed.services.radicle.httpd.listenPort})
      seed.wait_for_open_port(443)
      assert alice.succeed("curl -sS 'https://${nodes.seed.services.radicle.httpd.nginx.serverName}/api/v1' | jq -r .nid") == "${seed-nid}\n"
      assert bob.succeed("curl -sS 'https://${nodes.seed.services.radicle.httpd.nginx.serverName}/api/v1' | jq -r .nid") == "${seed-nid}\n"

    with subtest("alice can create a Node ID"):
      alice.succeed("rad auth --alias alice --stdin </dev/null")
      alice.copy_from_host("${radicleConfig args "alice"}", "/root/.radicle/config.json")
    with subtest("alice can run a node"):
      alice.succeed("rad node start")
    with subtest("alice can create a Git repository"):
      alice.succeed(
        "mkdir /tmp/repo",
        "git -C /tmp/repo init",
        "echo hello world > /tmp/repo/testfile",
        "git -C /tmp/repo add .",
        "git -C /tmp/repo commit -m init"
      )
    with subtest("alice can create a Repository ID"):
      alice.succeed(
        "cd /tmp/repo && rad init --name repo --description descr --default-branch main --public"
      )
    alice_repo_rid=alice.succeed("cd /tmp/repo && rad inspect --rid").rstrip("\n")
    with subtest("alice can send a repository to the seed"):
      alice.succeed(f"rad sync --seed ${seed-nid} {alice_repo_rid}")

    with subtest(f"seed can receive the repository {alice_repo_rid}"):
      seed.wait_until_succeeds("test 1 = \"$(rad-system stats | jq .local.repos)\"")

    with subtest("bob can create a Node ID"):
      bob.succeed("rad auth --alias bob --stdin </dev/null")
      bob.copy_from_host("${radicleConfig args "bob"}", "/root/.radicle/config.json")
      bob.succeed("rad node start")
    with subtest("bob can clone alice's repository from the seed"):
      bob.succeed(f"rad clone {alice_repo_rid} /tmp/repo")
      assert bob.succeed("cat /tmp/repo/testfile") == "hello world\n"

    with subtest("bob can clone alice's repository from the seed through the HTTP gateway"):
      bob.succeed(f"git clone https://${nodes.seed.services.radicle.httpd.nginx.serverName}/{alice_repo_rid[4:]}.git /tmp/repo-http")
      assert bob.succeed("cat /tmp/repo-http/testfile") == "hello world\n"

    with subtest("alice can push the main branch to the rad remote"):
      alice.succeed(
        "echo hello bob > /tmp/repo/testfile",
        "git -C /tmp/repo add .",
        "git -C /tmp/repo commit -m 'hello to bob'",
        "git -C /tmp/repo push rad main"
      )
    with subtest("bob can sync bob's repository from the seed"):
      bob.succeed(
        "cd /tmp/repo && rad sync --seed ${seed-nid}",
        "cd /tmp/repo && git pull"
      )
      assert bob.succeed("cat /tmp/repo/testfile") == "hello bob\n"

    with subtest("bob can push a patch"):
      bob.succeed(
        "echo hello alice > /tmp/repo/testfile",
        "git -C /tmp/repo checkout -b for-alice",
        "git -C /tmp/repo add .",
        "git -C /tmp/repo commit -m 'hello to alice'",
        "git -C /tmp/repo push -o patch.message='hello for alice' rad HEAD:refs/patches"
      )

    bob_repo_patch1_pid=bob.succeed("cd /tmp/repo && git branch --remotes | sed -ne 's:^ *rad/patches/::'p").rstrip("\n")
    with subtest("alice can receive the patch"):
      alice.wait_until_succeeds("test 1 = \"$(rad stats | jq .local.patches)\"")
      alice.succeed(
        f"cd /tmp/repo && rad patch show {bob_repo_patch1_pid} | grep 'opened by bob'",
        f"cd /tmp/repo && rad patch checkout {bob_repo_patch1_pid}"
      )
      assert alice.succeed("cat /tmp/repo/testfile") == "hello alice\n"
    with subtest("alice can comment the patch"):
      alice.succeed(
        f"cd /tmp/repo && rad patch comment {bob_repo_patch1_pid} -m thank-you"
      )
    with subtest("alice can merge the patch"):
      alice.succeed(
        "git -C /tmp/repo checkout main",
        f"git -C /tmp/repo merge patch/{bob_repo_patch1_pid[:7]}",
        "git -C /tmp/repo push rad main",
        "cd /tmp/repo && rad patch list | grep -qxF 'Nothing to show.'"
      )
  '';
}
