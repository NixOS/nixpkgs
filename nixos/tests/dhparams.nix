{
  name = "dhparams";

  nodes.machine =
    { pkgs, ... }:
    {
      security.dhparams.enable = true;
      environment.systemPackages = [ pkgs.openssl ];

      specialisation = {
        gen1.configuration =
          { config, ... }:
          {
            security.dhparams.params = {
              # Use low values here because we don't want the test to run for ages.
              foo.bits = 1024;
              # Also use the old format to make sure the type is coerced in the right
              # way.
              bar = 1025;
            };

            systemd.services.foo = {
              description = "Check systemd Ordering";
              wantedBy = [ "multi-user.target" ];
              before = [ "shutdown.target" ];
              conflicts = [ "shutdown.target" ];
              unitConfig = {
                # This is to make sure that the dhparams generation of foo occurs
                # before this service so we need this service to start as early as
                # possible to provoke a race condition.
                DefaultDependencies = false;

                # We check later whether the service has been started or not.
                ConditionPathExists = config.security.dhparams.params.foo.path;
              };
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              # The reason we only provide an ExecStop here is to ensure that we don't
              # accidentally trigger an error because a file system is not yet ready
              # during very early startup (we might not even have the Nix store
              # available, for example if future changes in NixOS use systemd mount
              # units to do early file system initialisation).
              serviceConfig.ExecStop = "${pkgs.coreutils}/bin/true";
            };
          };
        gen2.configuration = {
          security.dhparams.params.foo.bits = 1026;
        };
        gen3.configuration = { };
        gen4.configuration = {
          security.dhparams.stateful = false;
          security.dhparams.params.foo2.bits = 1027;
          security.dhparams.params.bar2.bits = 1028;
        };
        gen5.configuration = {
          security.dhparams.defaultBitSize = 1029;
          security.dhparams.params.foo3 = { };
          security.dhparams.params.bar3 = { };
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      getParamPath =
        gen: name:
        let
          node = "gen${toString gen}";
        in
        nodes.machine.config.specialisation.${node}.configuration.security.dhparams.params.${name}.path;

      switchToGeneration =
        gen:
        let
          switchCmd = "${nodes.machine.config.system.build.toplevel}/specialisation/gen${toString gen}/bin/switch-to-configuration test";
        in
        ''
          with machine.nested("switch to generation ${toString gen}"):
            machine.succeed("${switchCmd}")
        '';

    in
    ''
      import re


      def assert_param_bits(path, bits):
          with machine.nested(f"check bit size of {path}"):
              output = machine.succeed(f"openssl dhparam -in {path} -text")
              pattern = re.compile(r"^\s*DH Parameters:\s+\((\d+)\s+bit\)\s*$", re.M)
              match = pattern.match(output)
              if match is None:
                  raise Exception("bla")
              if match[1] != str(bits):
                  raise Exception(f"bit size should be {bits} but it is {match[1]} instead.")

      machine.wait_for_unit("multi-user.target")
      ${switchToGeneration 1}

      with subtest("verify startup order"):
          machine.succeed("systemctl is-active foo.service")

      with subtest("check bit sizes of dhparam files"):
          assert_param_bits("${getParamPath 1 "foo"}", 1024)
          assert_param_bits("${getParamPath 1 "bar"}", 1025)

      ${switchToGeneration 2}

      with subtest("check whether bit size has changed"):
          assert_param_bits("${getParamPath 2 "foo"}", 1026)

      with subtest("ensure that dhparams file for 'bar' was deleted"):
          machine.fail("test -e ${getParamPath 1 "bar"}")

      ${switchToGeneration 3}

      with subtest("ensure that 'security.dhparams.path' has been deleted"):
          machine.fail("test -e ${nodes.machine.config.specialisation.gen3.configuration.security.dhparams.path}")

      ${switchToGeneration 4}

      with subtest("check bit sizes dhparam files"):
          assert_param_bits(
              "${getParamPath 4 "foo2"}", 1027
          )
          assert_param_bits(
              "${getParamPath 4 "bar2"}", 1028
          )

      with subtest("check whether dhparam files are in the Nix store"):
          machine.succeed(
              "expr match ${getParamPath 4 "foo2"} ${builtins.storeDir}",
              "expr match ${getParamPath 4 "bar2"} ${builtins.storeDir}",
          )

      ${switchToGeneration 5}

      with subtest("check whether defaultBitSize works as intended"):
          assert_param_bits("${getParamPath 5 "foo3"}", 1029)
          assert_param_bits("${getParamPath 5 "bar3"}", 1029)
    '';
}
