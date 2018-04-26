let
  common = { pkgs, ... }: {
    security.dhparams.enable = true;
    environment.systemPackages = [ pkgs.openssl ];
  };

in import ./make-test.nix {
  name = "dhparams";

  nodes.generation1 = { pkgs, config, ... }: {
    imports = [ common ];
    security.dhparams.params.foo = 16;
    security.dhparams.params.bar = 17;

    systemd.services.foo = {
      description = "Check systemd Ordering";
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        # This is to make sure that the dhparams generation of foo occurs
        # before this service so we need this service to start as early as
        # possible to provoke a race condition.
        DefaultDependencies = false;

        # We check later whether the service has been started or not.
        ConditionPathExists = "${config.security.dhparams.path}/foo.pem";
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
    security.dhparams.params.foo = 18;
  };

  nodes.generation3 = common;

  testScript = { nodes, ... }: let
    getParamPath = gen: name: let
      node = "generation${toString gen}";
      inherit (nodes.${node}.config.security.dhparams) path;
    in "${path}/${name}.pem";

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
  '';
}
