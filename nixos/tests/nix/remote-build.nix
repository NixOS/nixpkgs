{ pkgs, lib, ... }:
let
  inherit (import ../ssh-keys.nix pkgs) snakeOilEd25519PrivateKey snakeOilEd25519PublicKey;
in
{
  name = "nix-remote-build";

  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes = {
    builder = {
      networking.hostName = "myBuildMachine";
      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
    };

    client = {
      nix.settings.max-jobs = 0;
      nix.settings.substituters = lib.mkForce [ ];
      nix.distributedBuilds = true;
      nix.buildMachines = [
        {
          hostName = "myBuildMachine";
          system = pkgs.stdenv.hostPlatform.system;
          sshUser = "root";
          sshKey = "/root/.ssh/id_ed25519";
        }
      ];

      programs.ssh.extraConfig = ''
        Host myBuildMachine
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
      '';
    };
  };

  testScript =
    let
      remoteBuildExpr = pkgs.writeText "remote-build-test.nix" ''
        derivation {
          name = "remote-build-test";
          system = builtins.currentSystem;
          builder = "/bin/sh";
          args = [ "-c" "echo -n hello > $out" ];
        }
      '';
    in
    ''
      start_all()

      builder.wait_for_unit("sshd.service")
      client.wait_for_unit("multi-user.target")

      client.succeed(
          "install -Dm600 ${snakeOilEd25519PrivateKey} /root/.ssh/id_ed25519"
      )

      with subtest("Client can reach the remote builder over ssh"):
          client.succeed("ssh -o BatchMode=yes myBuildMachine true")

      with subtest("Builds are delegated to the remote builder"):
          out = client.succeed(
              "nix-build -o /root/result ${remoteBuildExpr} 2>&1"
          )
          assert "on 'ssh://root@myBuildMachine'" in out, (
              f"expected nix-build to report delegating the build to 'builder', got:\n{out}"
          )

          nix_store_path = client.succeed("readlink -f /root/result").strip()
          assert builder.succeed(f"cat {nix_store_path}").strip() == "hello"
          assert client.succeed(f"cat {nix_store_path}").strip() == "hello"
    '';
}
