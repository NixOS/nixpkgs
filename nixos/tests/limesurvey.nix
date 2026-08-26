{ lib, pkgs, ... }:

{
  name = "limesurvey";
  meta.maintainers = [ lib.maintainers.aanderse ];

  nodes.machine = {
    services.limesurvey = {
      enable = true;
      httpd.virtualHost = {
        hostName = "example.local";
        adminAddr = "root@example.local";
      };
      encryptionKeyFile = pkgs.writeText "key" (lib.strings.replicate 32 "0");
      encryptionNonceFile = pkgs.writeText "nonce" (lib.strings.replicate 24 "0");
    };

    # limesurvey won't work without a dot in the hostname
    networking.hosts."127.0.0.1" = [ "example.local" ];

    specialisation.nginx = {
      inheritParentConfig = true;
      configuration.services.limesurvey = {
        webserver = "nginx";
        nginx.virtualHost.serverName = "example.local";
      };
    };
  };

  testScript =
    { nodes, ... }:
    ''
      def test():
        machine.wait_until_succeeds("curl --fail --silent http://example.local/ | grep -q 'The following surveys are available'")

      start_all()

      machine.wait_for_unit("phpfpm-limesurvey.service")
      machine.wait_for_unit("httpd.service")
      machine.wait_for_open_port(80)
      test()

      machine.execute("${nodes.machine.system.build.toplevel}/specialisation/nginx/bin/switch-to-configuration test")

      machine.wait_for_unit("nginx.service")
      test()


    '';
}
