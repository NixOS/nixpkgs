import ./make-test-python.nix ({ pkgs, ... }:

let
  configDir = "/var/lib/forked-daapd";
  port = 3689;
in {
  name = "forked-daapd";
  meta = with pkgs.stdenv.lib; {
    maintainers = with maintainers; [ flyfloh ];
  };

  nodes = {
    forked_daapd =
      { pkgs, ... }:
      {
        services.forked-daapd = {
          enable = true;
          libraryPaths = [ "/media/music" ];
          home = configDir;
          openFirewall = true;
          config = {
            general = {
              loglevel = "debug";
            };
          };
        };
      };
  };

  testScript = ''
    start_all()
    forked_daapd.wait_for_unit("forked-daapd.service")
    with subtest("Check that the web interface can be reached"):
        forked_daapd.wait_for_open_port(${toString port})
        forked_daapd.succeed("curl --fail http://localhost:${toString port}/")
    with subtest("Print log to ease debugging"):
        output_log = forked_daapd.succeed("cat ${configDir}/forked-daapd.log")
        print("\n### forked_daapd.log ###\n")
        print(output_log + "\n")

    with subtest("Check that no errors were logged"):
        assert "ERROR" not in output_log
  '';
})
