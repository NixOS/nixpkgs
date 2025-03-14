{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib)
    concatStringsSep
    maintainers
    mapAttrs
    mkMerge
    removeSuffix
    splitString
    ;

  tests = {
    default = {
      calibreConfig = { };
      calibreScript = ''
        wait_for_unit("calibre-server.service")
      '';
    };
    customLibrary = {
      calibreConfig = {
        libraries = [ "/var/lib/calibre-data" ];
      };
      calibreScript = ''
        succeed("ls -la /var/lib/calibre-data")
        wait_for_unit("calibre-server.service")
      '';
    };
    multipleLibraries = {
      calibreConfig = {
        libraries = [
          "/var/lib/calibre-data"
          "/var/lib/calibre-server"
        ];
      };
      calibreScript = ''
        succeed("ls -la /var/lib/calibre-data")
        succeed("ls -la /var/lib/calibre-server")
        wait_for_unit("calibre-server.service")
      '';
    };
    hostAndPort = {
      calibreConfig = {
        host = "127.0.0.1";
        port = 8888;
      };
      calibreScript = ''
        wait_for_unit("calibre-server.service")
        wait_for_open_port(8888)
        succeed("curl --fail http://127.0.0.1:8888")
      '';
    };
    basicAuth = {
      calibreConfig = {
        host = "127.0.0.1";
        port = 8888;
        auth = {
          enable = true;
          mode = "basic";
        };
      };
      calibreScript = ''
        wait_for_unit("calibre-server.service")
        wait_for_open_port(8888)
        fail("curl --fail http://127.0.0.1:8888")
      '';
    };
  };
in
mapAttrs (
  test: testConfig:
  (makeTest (
    let
      nodeName = testConfig.nodeName or test;
      calibreConfig = {
        enable = true;
        libraries = [ "/var/lib/calibre-server" ];
      } // testConfig.calibreConfig or { };
      librariesInitScript = path: ''
        ${nodeName}.execute("touch /tmp/test.epub")
        ${nodeName}.execute("zip -r /tmp/test.zip /tmp/test.epub")
        ${nodeName}.execute("mkdir -p ${path}")
        ${nodeName}.execute("calibredb add -d --with-library ${path} /tmp/test.zip")
      '';
    in
    {
      name = "calibre-server-${test}";

      nodes.${nodeName} = mkMerge [
        {
          environment.systemPackages = [ pkgs.zip ];
          services.calibre-server = calibreConfig;
        }
        testConfig.calibreProvider or { }
      ];

      testScript = ''
        ${nodeName}.start()
        ${concatStringsSep "\n" (map librariesInitScript calibreConfig.libraries)}
        ${concatStringsSep "\n" (
          map (
            line:
            if (builtins.substring 0 1 line == " " || builtins.substring 0 1 line == ")") then
              line
            else
              "${nodeName}.${line}"
          ) (splitString "\n" (removeSuffix "\n" testConfig.calibreScript))
        )}
        ${nodeName}.shutdown()
      '';

      meta = with maintainers; {
        maintainers = [ gaelreyrol ];
      };
    }
  ))
) tests
