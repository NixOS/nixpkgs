import ./make-test-python.nix (
  let
    host = "127.0.0.1";
    port = 1234;
  in
  { pkgs, ... }:
  {
    name = "stash";
    meta.maintainers = pkgs.stash.meta.maintainers;

    nodes.machine = {
      services.stash = {
        enable = true;

        jwtSecretKeyFile = builtins.toFile "jwt_secret_key" "secretkey";
        sessionStoreKeyFile = builtins.toFile "session_store_key" "yekterces";

        plugins =
          let
            src = pkgs.fetchFromGitHub {
              owner = "stashapp";
              repo = "CommunityScripts";
              rev = "main";
              hash = "sha256-H2BbBiOL0TaKDk2L3U03ifYDsyQQ+y0LCsyRRcAIUfE=";
            };
          in
          [
            (pkgs.runCommand "stashNotes" { inherit src; } ''
              mkdir -p $out/plugins
              cp -r $src/plugins/stashNotes $out/plugins/stashNotes
            '')
            (pkgs.runCommand "Theme-Plex" { inherit src; } ''
              mkdir -p $out/plugins
              cp -r $src/themes/Theme-Plex $out/plugins/Theme-Plex
            '')
          ];

        mutableScrapers = true;
        scrapers =
          let
            src = pkgs.fetchFromGitHub {
              owner = "stashapp";
              repo = "CommunityScrapers";
              rev = "master";
              hash = "sha256-65QLUewkIxLVfbLZRs6BFuv3oSj/CwVa08iRyXTb5QU=";
            };
          in
          [
            (pkgs.runCommand "FTV" { inherit src; } ''
              mkdir -p $out/scrapers/FTV
              cp -r $src/scrapers/FTV.yml $out/scrapers/FTV
            '')
          ];

        settings = {
          inherit host port;
          stash = [ { path = "/media/drive/stash"; } ];
        };
      };
    };

    testScript = ''
      machine.wait_for_unit("stash.service")
      machine.wait_for_open_port(${toString port}, "${host}")
      machine.succeed("curl --fail http://${host}:${toString port}/")

      with subtest("Test plugins/scrapers"):
        with subtest("mutable plugins directory should not exist"):
          machine.fail("test -d /var/lib/stash/plugins")
        with subtest("mutable scrapers directory should exist and scraper FTV should be linked"):
          machine.succeed("test -L /var/lib/stash/scrapers/FTV")
    '';
  }
)
