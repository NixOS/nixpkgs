import ./make-test-python.nix ({ lib, pkgs, ... }:
  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  in {
    name = "ssh-agent-auth";
    meta.maintainers = with lib.maintainers; [ nicoo ];

    nodes = let nodeConfig = n: { ... }: {
      users.users = {
        admin = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
        };
        foo.isNormalUser = true;
      };

      security.pam.enableSSHAgentAuth = true;
      security.${lib.replaceStrings [ "_" ] [ "-" ] n} = {
        enable = true;
        wheelNeedsPassword = true;  # We are checking `pam_ssh_agent_auth(8)` works for a sudoer
      };

      # Necessary for pam_ssh_agent_auth  >_>'
      services.openssh.enable = true;
    };
    in lib.genAttrs [ "sudo" "sudo_rs" ] nodeConfig;

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
      for vm in (sudo, sudo_rs):
        sudo_impl = vm.name.replace("_", "-")
        with subtest(f"wheel user can auth with ssh-agent for {sudo_impl}"):
            vm.copy_from_host("${snakeOilPrivateKey}", "${privateKeyPath}")
            vm.succeed("chmod -R 0700 /home/admin")
            vm.succeed("chown -R admin:users /home/admin")

            # Run `userScript` in an environment with an SSH-agent available
            assert vm.succeed("sudo -u admin -- ssh-agent ${userScript} 2>&1").strip() == "foo"
    '';
  }
)
