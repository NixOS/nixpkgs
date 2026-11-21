{ lib, ... }:

let
  password = "s3cRe!p4SsW0rD";

  common =
    { pkgs, ... }:

    {
      services.lavalink = {
        enable = true;
        passwordFile = "/etc/lavalink-password";

        settings = {
          # Disable deprecated youtube source
          lavalink.server.sources.youtube = false;
          # Disable twitch web requests
          lavalink.server.sources.twitch = false;
        };
      };

      environment.etc."lavalink-password".text = password;

      # Imitate the actual repository
      # so that the plugin update check doesn't
      # crash the program
      services.httpd = {
        enable = true;
        virtualHosts."maven.lavalink.dev".locations."/releases/dev/lavalink/youtube/youtube-plugin/maven-metadata.xml".alias =
          pkgs.writeText "maven-metadata.xml" ''
            <metadata>
              <groupId>dev.lavalink.youtube</groupId>
              <artifactId>youtube-plugin</artifactId>
              <versioning>
                <latest>1.16.0</latest>
                <release>1.16.0</release>
                <versions>
                  <version>1.16.0</version>
                </versions>
                <lastUpdated>20251103203930</lastUpdated>
              </versioning>
            </metadata>
          '';
      };

      networking.hosts."127.0.0.1" = [ "maven.lavalink.dev" ];
    };
in

{
  name = "lavalink";
  meta.maintainers = with lib.maintainers; [ nanoyaki ];

  nodes = {
    default_2605.imports = [
      common

      {
        services.lavalink.settings.server.port = 1234;
        services.lavalink.plugins.youtube = {
          # Use http for the test; the fetcher
          # will redirect automatically anyway
          repository = "http://maven.lavalink.dev/releases";
          dependency = "dev.lavalink.youtube:youtube-plugin:1.16.0";
          hash = "sha256-wKD+C7Y3nj+MpQDIRWvSIJ678jnRxzxEW0e0JkoszA4=";

          settings.enabled = true;
        };
      }
    ];

    deprecated.imports = [
      common

      {
        services.lavalink.settings.server.port = 1235;
        services.lavalink.plugins = [
          {
            # Use http for the test; the fetcher
            # will redirect automatically anyway
            repository = "http://maven.lavalink.dev/releases";
            dependency = "dev.lavalink.youtube:youtube-plugin:1.16.0";
            hash = "sha256-wKD+C7Y3nj+MpQDIRWvSIJ678jnRxzxEW0e0JkoszA4=";

            configName = "youtube";
            extraConfig.enabled = true;
          }
        ];
      }
    ];
  };

  testScript = ''
    start_all()

    default_2605.wait_for_unit('lavalink.service')
    default_2605.wait_for_open_port(1234)
    default_2605.succeed(
      'curl --fail -v '
      + '--header "User-Id: 1204475253028429844" '
      + '--header "Client-Name: shoukaku/4.1.1" '
      + '--header "Authorization: ${password}" '
      + 'http://localhost:1234/v4/info'
    )

    deprecated.wait_for_unit('lavalink.service')
    deprecated.wait_for_open_port(1235)
    deprecated.succeed(
      'curl --fail -v '
      + '--header "User-Id: 1204475253028429844" '
      + '--header "Client-Name: shoukaku/4.1.1" '
      + '--header "Authorization: ${password}" '
      + 'http://localhost:1235/v4/info'
    )
  '';
}
