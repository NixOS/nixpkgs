{ lib, pkgs, ... }:

{
  name = "ocis-environment-only";

  meta.maintainers = with lib.maintainers; [ ramblurr ];

  nodes.machine = {
    services.ocis = {
      enable = true;
      package = pkgs.ocis_81-bin;
    };

    # The wrapper must work even when an environment-only deployment does not
    # start the server or create the default configuration directory.
    systemd.services.ocis.wantedBy = lib.mkForce [ ];
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("test ! -e /var/lib/ocis/config")
    machine.succeed("ocisadm --help")
  '';
}
