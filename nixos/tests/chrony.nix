import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "chrony";

    meta = {
      maintainers = with lib.maintainers; [ fpletz ];
    };

    nodes = {
      default = {
        services.chrony.enable = true;
      };
      graphene-hardened = {
        services.chrony.enable = true;
        services.chrony.enableMemoryLocking = true;
        environment.memoryAllocator.provider = "graphene-hardened";
        # dhcpcd privsep is incompatible with graphene-hardened
        networking.useNetworkd = true;
      };
    };

    testScript =
      { nodes, ... }:
      let
        graphene-hardened = nodes.graphene-hardened.system.build.toplevel;
      in
      ''
        default.start()
        default.wait_for_unit('multi-user.target')
        default.succeed('systemctl is-active chronyd.service')
        default.succeed('${graphene-hardened}/bin/switch-to-configuration test')
        default.succeed('systemctl is-active chronyd.service')
      '';
  }
)
