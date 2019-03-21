let
  common = { pkgs, ... }: {
    security.dhparams.enable = true;
    environment.systemPackages = [ pkgs.openssl ];
  };

in import ./make-test.nix {
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

    assertParamBits = gen: name: bits: let
      path = getParamPath gen name;
    in ''
      $machine->nest('check bit size of ${path}', sub {
        my $out = $machine->succeed('openssl dhparam -in ${path} -text');
        $out =~ /^\s*DH Parameters:\s+\((\d+)\s+bit\)\s*$/m;
        die "bit size should be ${toString bits} but it is $1 instead."
          if $1 != ${toString bits};
      });
    '';

    switchToGeneration = gen: let
      node = "generation${toString gen}";
      inherit (nodes.${node}.config.system.build) toplevel;
      switchCmd = "${toplevel}/bin/switch-to-configuration test";
    in ''
      $machine->nest('switch to generation ${toString gen}', sub {
        $machine->succeed('${switchCmd}');
        $main::machine = ''$${node};
      });
    '';

  in ''
    my $machine = $generation1;

    $machine->waitForUnit('multi-user.target');

    subtest "verify startup order", sub {
      $machine->succeed('systemctl is-active foo.service');
    };

    subtest "check bit sizes of dhparam files", sub {
      ${assertParamBits 1 "foo" 16}
      ${assertParamBits 1 "bar" 17}
    };

    ${switchToGeneration 2}

    subtest "check whether bit size has changed", sub {
      ${assertParamBits 2 "foo" 18}
    };

    subtest "ensure that dhparams file for 'bar' was deleted", sub {
      $machine->fail('test -e ${getParamPath 1 "bar"}');
    };

    ${switchToGeneration 3}

    subtest "ensure that 'security.dhparams.path' has been deleted", sub {
      $machine->fail(
        'test -e ${nodes.generation3.config.security.dhparams.path}'
      );
    };

    ${switchToGeneration 4}

    subtest "check bit sizes dhparam files", sub {
      ${assertParamBits 4 "foo2" 18}
      ${assertParamBits 4 "bar2" 19}
    };

    subtest "check whether dhparam files are in the Nix store", sub {
      $machine->succeed(
        'expr match ${getParamPath 4 "foo2"} ${builtins.storeDir}',
        'expr match ${getParamPath 4 "bar2"} ${builtins.storeDir}',
      );
    };

    ${switchToGeneration 5}

    subtest "check whether defaultBitSize works as intended", sub {
      ${assertParamBits 5 "foo3" 30}
      ${assertParamBits 5 "bar3" 30}
    };
  '';
}
