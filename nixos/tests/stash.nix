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

    nodes.machine =
      { config, ... }:
      {
        services.stash = {
          inherit dataDir;
          enable = true;

          username = "test";
          passwordFile.output = config.testing.hardcoded-secret."stash-password".output;

          jwtSecretKey.output.path = config.testing.hardcoded-secret."jwt_secret_key".output.path;
          sessionStoreKey.output.path = config.testing.hardcoded-secret."session_store_key".output.path;

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
        testing.hardcoded-secret."stash-password" = {
          input = config.services.stash.passwordFile.input;
          content = "MyPassword";
        };
        testing.hardcoded-secret."jwt_secret_key" = {
          input = config.services.stash.jwtSecretKey.input;
          content = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        };
        testing.hardcoded-secret."session_store_key" = {
          input = config.services.stash.sessionStoreKey.input;
          content = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
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
