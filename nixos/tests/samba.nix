import ./make-test-python.nix ({ pkgs, ... }: {
  name = "samba";

  meta.maintainers = [ ];

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

  # client# [    4.542997] mount[777]: sh: systemd-ask-password: command not found

  testScript = ''
    server.start()
    server.wait_for_unit("samba.target")
    server.succeed("mkdir -p /public; echo bar > /public/foo")

    client.start()
    client.wait_for_unit("remote-fs.target")
    client.succeed("[[ $(cat /public/foo) = bar ]]")
  '';
})
