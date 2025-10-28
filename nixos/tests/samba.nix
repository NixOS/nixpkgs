{ lib, ... }:
{
  name = "samba";

  meta.maintainers = [ lib.maintainers.anthonyroussel ];

  nodes = {
    client =
      { ... }:
      {
        virtualisation.fileSystems = {
          "/public" = {
            fsType = "cifs";
            device = "//server/public";
            options = [ "guest" ];
          };
        };
      };

    server =
      { ... }:
      {
        services.samba = {
          enable = true;
          openFirewall = true;
          settings = {
            "public" = {
              "path" = "/public";
              "read only" = true;
              "browseable" = "yes";
              "guest ok" = "yes";
              "comment" = "Public samba share.";
            };
          };
        };
      };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("samba.target")
    server.succeed("mkdir -p /public; echo bar > /public/foo")

    client.start()
    client.wait_for_unit("remote-fs.target")
    client.succeed("[[ $(cat /public/foo) = bar ]]")
  '';
}
