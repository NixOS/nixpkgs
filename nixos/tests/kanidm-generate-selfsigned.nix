import ./make-test-python.nix (
  { pkgs, ... }:
  let
    serverDomain = "kanidm.test";
  in
  {
    name = "kanidm";
    meta.maintainers = with pkgs.lib.maintainers; [
      Flakebi
      oddlama
    ];

    nodes.server =
      { pkgs, ... }:
      {
        services.kanidm = {
          enableServer = true;
          generateSelfSigned = true;
          serverSettings = {
            origin = "https://${serverDomain}";
            domain = serverDomain;
            bindaddress = "[::]:443";
            ldapbindaddress = "[::1]:636";
          };
        };

        networking.hosts."::1" = [ serverDomain ];
        networking.firewall.allowedTCPPorts = [ 443 ];

        users.users.kanidm.shell = pkgs.bashInteractive;

        environment.systemPackages = with pkgs; [
          kanidm
          openldap
          ripgrep
        ];
      };

    testScript = ''
      server.start()
      server.wait_for_unit("kanidm.service")
      with subtest("Test HTTP interface"):
          server.wait_until_succeeds("curl -kLsf https://${serverDomain} | grep Kanidm")
    '';
  }
)
