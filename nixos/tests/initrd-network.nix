import ./make-test.nix ({ pkgs, ...} : {
  name = "initrd-network";

  meta.maintainers = [ pkgs.stdenv.lib.maintainers.eelco ];

  machine = { config, pkgs, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
    boot.initrd.network.enable = true;
    boot.initrd.network.postCommands =
      ''
        ip addr | grep 10.0.2.15 || exit 1
        ping -c1 10.0.2.2 || exit 1
      '';
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("ip link >&2");
    '';
})
