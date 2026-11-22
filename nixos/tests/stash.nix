import ./make-test-python.nix (
  let
    host = "127.0.0.1";
    port = 1234;
    dataDir = "/stash";
  in
  { pkgs, ... }:
  {
    name = "stash";
    meta.maintainers = pkgs.stash.meta.maintainers;

    nodes.machine = {
      services.stash = {
        inherit dataDir;
        enable = true;

        username = "test";
        passwordFile = pkgs.writeText "stash-password" "MyPassword";

        jwtSecretKeyFile = pkgs.writeText "jwt_secret_key" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        sessionStoreKeyFile = pkgs.writeText "session_store_key" "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";

        plugins =
          let
            src = pkgs.fetchFromGitHub {
              owner = "stashapp";
              repo = "CommunityScripts";
              rev = "9b6fac4934c2fac2ef0859ea68ebee5111fc5be5";
              hash = "sha256-PO3J15vaA7SD4r/LyHlXjnpaeYAN9Q++O94bIWdz7OA=";
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
              rev = "2ece82d17ddb0952c16842b0775274bcda598d81";
              hash = "sha256-AEmnvM8Nikhue9LNF9dkbleYgabCvjKHtzFpMse4otM=";
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

          stash = [ { path = "/srv"; } ];
        };
      };
    };

    testScript = ''
      machine.wait_for_unit("stash.service")
      machine.wait_for_open_port(${toString port}, "${host}")
      machine.succeed("curl --fail http://${host}:${toString port}/")

      with subtest("Test plugins/scrapers"):
        with subtest("mutable plugins directory should not exist"):
          machine.fail("test -d ${dataDir}/plugins")
        with subtest("mutable scrapers directory should exist and scraper FTV should be linked"):
          machine.succeed("test -L ${dataDir}/scrapers/FTV")
    '';
  }
)
