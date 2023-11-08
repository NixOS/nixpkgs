import ./make-test-python.nix ({ lib, pkgs, ... }:
  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  in {
    name = "ssh-agent-auth";
    meta.maintainers = with lib.maintainers; [ nicoo ];

    nodes.sudoVM = { lib, ... }: {
      users.users = {
        admin = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
        };
        foo.isNormalUser = true;
      };

      security.pam.enableSSHAgentAuth = true;
      security.sudo = {
        enable = true;
        wheelNeedsPassword = true;  # We are checking `pam_ssh_agent_auth(8)` works for a sudoer
      };

      # Necessary for pam_ssh_agent_auth  >_>'
      services.openssh.enable = true;
    };

    testScript = let
      privateKeyPath = "/home/admin/.ssh/id_ecdsa";
      userScript = pkgs.writeShellScript "test-script" ''
        set -e
        ssh-add -q ${privateKeyPath}

        # faketty needed to ensure `sudo` doesn't write to the controlling PTY,
        #  which would break the test-driver's line-oriented protocol.
        ${lib.getExe pkgs.faketty} sudo -u foo -- id -un
      '';
    in ''
      sudoVM.copy_from_host("${snakeOilPrivateKey}", "${privateKeyPath}")
      sudoVM.succeed("chmod -R 0700 /home/admin")
      sudoVM.succeed("chown -R admin:users /home/admin")

      with subtest("sudoer can auth through pam_ssh_agent_auth(8)"):
          # Run `userScript` in an environment with an SSH-agent available
          assert sudoVM.succeed("sudo -u admin -- ssh-agent ${userScript} 2>&1").strip() == "foo"
    '';
  }
)
