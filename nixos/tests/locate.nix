import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  in
  {
    name = "locate";
    meta.maintainers = with pkgs.lib.maintainers; [ chkno ];

    nodes = rec {
      a = {
        environment.systemPackages = with pkgs; [ sshfs ];
        virtualisation.fileSystems = {
          "/ssh" = {
            device = "alice@b:/";
            fsType = "fuse.sshfs";
            options = [
              "allow_other"
              "IdentityFile=/privkey"
              "noauto"
              "StrictHostKeyChecking=no"
              "UserKnownHostsFile=/dev/null"
            ];
          };
        };
        services.locate = {
          enable = true;
          interval = "*:*:0/5";
        };
      };
      b = {
        services.openssh.enable = true;
        users.users.alice = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
        };
      };
    };

    testScript = ''
      start_all()

      # Set up sshfs mount
      a.succeed(
          "(umask 077; cat ${snakeOilPrivateKey} > /privkey)"
      )
      b.succeed("touch /file-on-b-machine")
      b.wait_for_open_port(22)
      a.succeed("mkdir /ssh")
      a.succeed("mount /ssh")

      # Core locatedb functionality
      a.succeed("touch /file-on-a-machine-1")
      a.wait_for_file("/var/cache/locatedb")
      a.wait_until_succeeds("locate file-on-a-machine-1")

      # Wait for a second update to make sure we're using a locatedb from a run
      # that began after the sshfs mount
      a.succeed("touch /file-on-a-machine-2")
      a.wait_until_succeeds("locate file-on-a-machine-2")

      # We shouldn't be able to see files on the other machine
      a.fail("locate file-on-b-machine")
    '';
  }
)
