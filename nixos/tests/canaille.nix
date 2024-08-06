import ./make-test-python.nix (
  { pkgs, ... }:
  let
    certs = import ./common/acme/server/snakeoil-certs.nix;
    inherit (certs) domain;
  in
  {
    name = "canaille";
    meta.maintainers = with pkgs.lib.maintainers; [ erictapen ];

    nodes.server =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        services.canaille = {
          enable = true;
          secretKeyFile = pkgs.writeText "canaille-secret-key" ''
            this is not a secret key
          '';
        };
      };

    testScript =
      { nodes, ... }:
      ''
        start_all()
        server.wait_for_unit("canaille.service")
      '';
  }
)
