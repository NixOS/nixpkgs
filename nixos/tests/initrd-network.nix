import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "initrd-network";

  meta.maintainers = [ pkgs.lib.maintainers.eelco ];

  nodes.machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
    boot.initrd.network.enable = true;
    boot.initrd.network.postCommands =
      ''
        ip addr show
        ip route show
        ip addr | grep 10.0.2.15 || exit 1
        ping -c1 10.0.2.2 || exit 1
      '';
    # Check if cleanup was done correctly
    boot.initrd.postMountCommands = lib.mkAfter
      ''
        ip addr show
        ip route show
        ip addr | grep 10.0.2.15 && exit 1
        ping -c1 10.0.2.2 && exit 1
      '';
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("ip addr show >&2")
      machine.succeed("ip route show >&2")
    '';
})
