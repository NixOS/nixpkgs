let
  common = { pkgs, ... }: {
    security.dhparams.enable = true;
    environment.systemPackages = [ pkgs.openssl ];
  };

in import ./make-test-python.nix {
  name = "dhparams";

  nodes.generation1 = { pkgs, config, ... }: {
    imports = [ common ];
    security.dhparams.params = {
      # Use low values here because we don't want the test to run for ages.
      foo.bits = 16;
      # Also use the old format to make sure the type is coerced in the right
      # way.
      bar = 17;
    };

    systemd.services.foo = {
      description = "Check systemd Ordering";
      wantedBy = [ "multi-user.target" ];
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

  nodes.generation2 = {
    imports = [ common ];
    security.dhparams.params.foo.bits = 18;
  };

  nodes.generation3 = common;

  nodes.generation4 = {
    imports = [ common ];
    security.dhparams.stateful = false;
    security.dhparams.params.foo2.bits = 18;
    security.dhparams.params.bar2.bits = 19;
  };

  nodes.generation5 = {
    imports = [ common ];
    security.dhparams.defaultBitSize = 30;
    security.dhparams.params.foo3 = {};
    security.dhparams.params.bar3 = {};
  };

  testScript = { nodes, ... }: let
    getParamPath = gen: name: let
      node = "generation${toString gen}";
    in nodes.${node}.config.security.dhparams.params.${name}.path;

    switchToGeneration = gen: let
      node = "generation${toString gen}";
      inherit (nodes.${node}.config.system.build) toplevel;
      switchCmd = "${toplevel}/bin/switch-to-configuration test";
    in ''
      with machine.nested("switch to generation ${toString gen}"):
          machine.succeed(
              "${switchCmd}"
          )
          machine = ${node}
    '';

  in ''
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


    machine = generation1

    machine.wait_for_unit("multi-user.target")

    with subtest("verify startup order"):
        machine.succeed("systemctl is-active foo.service")

    with subtest("check bit sizes of dhparam files"):
        assert_param_bits("${getParamPath 1 "foo"}", 16)
        assert_param_bits("${getParamPath 1 "bar"}", 17)

    ${switchToGeneration 2}

    with subtest("check whether bit size has changed"):
        assert_param_bits("${getParamPath 2 "foo"}", 18)

    with subtest("ensure that dhparams file for 'bar' was deleted"):
        machine.fail("test -e ${getParamPath 1 "bar"}")

    ${switchToGeneration 3}

    with subtest("ensure that 'security.dhparams.path' has been deleted"):
        machine.fail("test -e ${nodes.generation3.config.security.dhparams.path}")

    ${switchToGeneration 4}

    with subtest("check bit sizes dhparam files"):
        assert_param_bits(
            "${getParamPath 4 "foo2"}", 18
        )
        assert_param_bits(
            "${getParamPath 4 "bar2"}", 19
        )

    with subtest("check whether dhparam files are in the Nix store"):
        machine.succeed(
            "expr match ${getParamPath 4 "foo2"} ${builtins.storeDir}",
            "expr match ${getParamPath 4 "bar2"} ${builtins.storeDir}",
        )

    ${switchToGeneration 5}

    with subtest("check whether defaultBitSize works as intended"):
        assert_param_bits("${getParamPath 5 "foo3"}", 30)
        assert_param_bits("${getParamPath 5 "bar3"}", 30)
  '';
}
