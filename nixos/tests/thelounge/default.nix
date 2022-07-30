import ../make-test-python.nix {
  name = "thelounge";

  nodes =
    let
      mkUnwrappedTestRunner =
        pkgs: pkgs.writers.writePython3 "test-runner-unwrapped"
          {
            libraries = [ pkgs.python3Packages.aiohttp ];
            flakeIgnore = [ "E501" ];
          }
          (builtins.readFile ./test-runner.py);
      mkTestRunner = cfg: pkgs: pkgs.writeShellScriptBin "test-runner" ''
        ${mkUnwrappedTestRunner pkgs} ${pkgs.lib.boolToString cfg.public} \
          ${pkgs.lib.boolToString ((builtins.length cfg.plugins) > 0)} "$@"
      '';
      password123 = "$2b$11$SqnMvKNEERan67wC9pQZX.MnCX2yXsTjh/EM0RLwhuZWq.Y/rGFLu";
      password321 = "$2b$11$hLH9.ym2E4HfhYjItUx7yusv5QvMPhHRZxU8v1QAtqtqVT5Z/wCxG";
    in
    {
      private = { config, pkgs, ... }: {
        services.thelounge = {
          enable = true;
          plugins = [ pkgs.theLoungePlugins.themes.solarized ];
          users = {
            john = {
              hashedPassword = password123;
            };
            jane =
              let
                file = pkgs.writeTextFile {
                  name = "jane-password";
                  text = config.services.thelounge.users.john.hashedPassword;
                };
              in
              {
                hashedPasswordFile = "${file}";
              };
          };
          mutableUsers = false;
        };

        environment.systemPackages = [ (mkTestRunner config.services.thelounge pkgs) ];

        specialisation.rmUser = {
          configuration = { config, pkgs, ... }: {
            services.thelounge = {
              enable = true;
              users = {
                john = {
                  hashedPassword = password321;
                };
              };
              mutableUsers = false;
            };

            environment.systemPackages = [ (mkTestRunner config.services.thelounge pkgs) ];
          };
          inheritParentConfig = false;
        };
      };

      public = { config, pkgs, ... }: {
        services.thelounge = {
          enable = true;
          public = true;
        };

        environment.systemPackages = [ (mkTestRunner config.services.thelounge pkgs) ];
      };

      privateMutable = { config, pkgs, ... }: {
        services.thelounge = {
          enable = true;
          users = {
            john = {
              hashedPassword = password123;
            };
            jane = {
              hashedPassword = config.services.thelounge.users.john.hashedPassword;
            };
          };
        };

        environment.systemPackages = [ (mkTestRunner config.services.thelounge pkgs) ];

        specialisation.rmUser = {
          configuration = { config, pkgs, ... }: {
            services.thelounge = {
              enable = true;
              users = {
                john = {
                  hashedPassword = password321;
                };
              };
            };

            environment.systemPackages = [ (mkTestRunner config.services.thelounge pkgs) ];
          };
          inheritParentConfig = false;
        };
      };
    };

  testScript = ''
    start_all()

    def wait_for_machine(machine):
      machine.wait_for_unit("thelounge.service")
      machine.wait_for_open_port(9000)

    with subtest("Public instance"):
        wait_for_machine(public)
        public.succeed("test-runner")

    with subtest("Private instance (immutable users)"):
        wait_for_machine(private)
        private.succeed("test-runner john password123")
        private.succeed("test-runner jane password123")

        for command in ["install foo", "uninstall foo", "outdated", "upgrade"]:
            private.succeed(f"sudo -u thelounge thelounge {command} |& grep NixOS")

        private.succeed("/run/current-system/specialisation/rmUser/bin/switch-to-configuration switch")
        wait_for_machine(private)
        private.succeed("test-runner john password321")
        private.fail("test-runner jane password123")

    with subtest("Private instance (mutable users)"):
        import time

        wait_for_machine(privateMutable)
        privateMutable.succeed("test-runner jane password123")

        privateMutable.succeed("sudo -u thelounge thelounge add bob --password foo")
        time.sleep(3)
        privateMutable.succeed("test-runner bob foo")

        privateMutable.succeed("/run/current-system/specialisation/rmUser/bin/switch-to-configuration switch")
        wait_for_machine(privateMutable)
        privateMutable.fail("test-runner jane password123")
        privateMutable.succeed("test-runner bob foo")
  '';
}
