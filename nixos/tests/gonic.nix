{ lib, pkgs, ... }:
{
  name = "gonic";
  meta.maintainers = pkgs.gonic.meta.maintainers;

  nodes.default_cache_dir =
    { config, ... }:
    {
      systemd.tmpfiles.settings = {
        "10-gonic" = {
          "/tmp/music"."d" = { };
          "/tmp/podcast"."d" = { };
          "/tmp/playlists"."d" = { };
          "/tmp/secrets"."d" = { };
        };
      };
      services.gonic = {
        enable = true;
        # Wrap gonic to check that the required paths are writable.
        # This isn't necessarily checked by successful service startup.
        package = pkgs.writeShellApplication {
          name = "gonic-test-wrapper";
          runtimeInputs = [ pkgs.gonic ];
          text = ''
            touch ${config.services.gonic.settings.cache-path}/foo && echo "cache dir writeable" >&2
            touch /tmp/podcast/foo && echo "podcast dir writeable" >&2
            touch /tmp/playlists/foo && echo "playlists dir writeable" >&2
            touch /tmp/secrets/foo && echo "shouldn't be able to write /tmp/secrets" >&2 && exit 1
            exec ${lib.getExe pkgs.gonic} "$@"
          '';
        };
        settings = {
          music-path = [ "/tmp/music" ];
          podcast-path = "/tmp/podcast";
          playlists-path = "/tmp/playlists";
        };
      };
    };

  nodes.custom_cache_dir =
    { ... }:
    {
      systemd.tmpfiles.settings = {
        "10-gonic" = {
          "/tmp/music"."d" = { };
          "/tmp/podcast"."d" = { };
          "/tmp/playlists"."d" = { };
          "/tmp/cache"."d" = { };
        };
      };
      services.gonic = {
        enable = true;
        settings = {
          music-path = [ "/tmp/music" ];
          podcast-path = "/tmp/podcast";
          playlists-path = "/tmp/playlists";
          cache-path = "/tmp/cache";
        };
      };
    };

  testScript = ''
    default_cache_dir.wait_for_unit("gonic")
    default_cache_dir.wait_for_open_port(4747)

    custom_cache_dir.wait_for_unit("gonic")
    custom_cache_dir.wait_for_open_port(4747)
  '';
}
