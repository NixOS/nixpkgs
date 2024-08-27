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

          jwt_secret_key = "5f410f59a9a483f0cca46dcf4421576d88b8f554f49ecb6dde9cfeb6953e";
          session_store_key = "c62259847259136c87612993c3554543627df82172e6a13b0a45d884b719";

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
