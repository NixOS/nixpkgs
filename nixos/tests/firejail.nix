import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "firejail";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ sgo ];
    };

    nodes.machine =
      { ... }:
      {
        imports = [ ./common/user-account.nix ];

        programs.firejail = {
          enable = true;
          wrappedBinaries = {
            bash-jailed = "${pkgs.bash}/bin/bash";
            bash-jailed2 = {
              executable = "${pkgs.bash}/bin/bash";
              extraArgs = [ "--private=~/firejail-home" ];
            };
          };
        };

        systemd.services.setupFirejailTest = {
          wantedBy = [ "multi-user.target" ];
          before = [ "multi-user.target" ];

          environment = {
            HOME = "/home/alice";
          };

          unitConfig = {
            type = "oneshot";
            RemainAfterExit = true;
            user = "alice";
          };

          script = ''
            cd $HOME

            mkdir .password-store && echo s3cret > .password-store/secret
            mkdir my-secrets && echo s3cret > my-secrets/secret

            echo publ1c > public

            mkdir -p .config/firejail
            echo 'blacklist ''${HOME}/my-secrets' > .config/firejail/globals.local
          '';
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")

      # Test path acl with wrapper
      machine.succeed("sudo -u alice bash-jailed -c 'cat ~/public' | grep -q publ1c")
      machine.fail(
          "sudo -u alice bash-jailed -c 'cat ~/.password-store/secret' | grep -q s3cret"
      )
      machine.fail("sudo -u alice bash-jailed -c 'cat ~/my-secrets/secret' | grep -q s3cret")

      # Test extraArgs
      machine.succeed("sudo -u alice mkdir /home/alice/firejail-home")
      machine.succeed("sudo -u alice bash-jailed2 -c 'echo test > /home/alice/foo'")
      machine.fail("sudo -u alice cat /home/alice/foo")
      machine.succeed("sudo -u alice cat /home/alice/firejail-home/foo | grep test")

      # Test path acl with firejail executable
      machine.succeed("sudo -u alice firejail -- bash -c 'cat ~/public' | grep -q publ1c")
      machine.fail(
          "sudo -u alice firejail -- bash -c 'cat ~/.password-store/secret' | grep -q s3cret"
      )
      machine.fail(
          "sudo -u alice firejail -- bash -c 'cat ~/my-secrets/secret' | grep -q s3cret"
      )

      # Disabling profiles
      machine.succeed(
          "sudo -u alice bash -c 'firejail --noprofile -- cat ~/.password-store/secret' | grep -q s3cret"
      )

      # CVE-2020-17367
      machine.fail(
          "sudo -u alice firejail --private-tmp id --output=/tmp/vuln1 && cat /tmp/vuln1"
      )

      # CVE-2020-17368
      machine.fail(
          "sudo -u alice firejail --private-tmp --output=/tmp/foo 'bash -c $(id>/tmp/vuln2;echo id)' && cat /tmp/vuln2"
      )
    '';
  }
)
