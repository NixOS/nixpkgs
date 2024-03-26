{ pkgs, lib, ... }:
let
  test_script = pkgs.stdenv.mkDerivation rec {
    pname = "stargazer-test-script";
    inherit (pkgs.stargazer) version src;
    buildInputs = with pkgs; [ (python3.withPackages (ps: with ps; [ cryptography ])) ];
    dontBuild = true;
    doCheck = false;
    installPhase = ''
      mkdir -p $out/bin
      cp scripts/gemini-diagnostics $out/bin/test
    '';
  };
  test_env = pkgs.stdenv.mkDerivation rec {
    pname = "stargazer-test-env";
    inherit (pkgs.stargazer) version src;
    buildPhase = ''
      cc test_data/cgi-bin/loop.c -o test_data/cgi-bin/loop
    '';
    doCheck = false;
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
  scgi_server = pkgs.stdenv.mkDerivation rec {
    pname = "stargazer-test-scgi-server";
    inherit (pkgs.stargazer) version src;
    buildInputs = with pkgs; [ python3 ];
    dontConfigure = true;
    dontBuild = true;
    doCheck = false;
    installPhase = ''
      mkdir -p $out/bin
      cp scripts/scgi-server $out/bin/scgi-server
    '';
  };
in
{
  name = "stargazer";
  meta = with lib.maintainers; { maintainers = [ gaykitty ]; };

  nodes = {
    geminiserver = { pkgs, ... }: {
      services.stargazer = {
        enable = true;
        connectionLogging = false;
        requestTimeout = 1;
        routes = [
          {
            route = "localhost";
            root = "${test_env}/test_data/test_site";
          }
          {
            route = "localhost=/en.gmi";
            root = "${test_env}/test_data/test_site";
            lang = "en";
            charset = "ascii";
          }
          {
            route = "localhost~/(.*).gemini";
            root = "${test_env}/test_data/test_site";
            rewrite = "\\1.gmi";
            lang = "en";
            charset = "ascii";
          }
          {
            route = "localhost=/plain.txt";
            root = "${test_env}/test_data/test_site";
            lang = "en";
            charset = "ascii";
            cert-path = "/var/lib/gemini/certs/localhost.crt";
            key-path = "/var/lib/gemini/certs/localhost.key";
          }
          {
            route = "localhost:/cgi-bin";
            root = "${test_env}/test_data";
            cgi = true;
            cgi-timeout = 5;
          }
          {
            route = "localhost:/scgi";
            scgi = true;
            scgi-address = "127.0.0.1:1099";
          }
          {
            route = "localhost=/root";
            redirect = "..";
            permanent = true;
          }
          {
            route = "localhost=/priv.gmi";
            root = "${test_env}/test_data/test_site";
            client-cert = "${test_env}/test_data/client_cert/good.crt";
          }
          {
            route = "example.com~(.*)";
            redirect = "gemini://localhost";
            rewrite = "\\1";
          }
          {
            route = "localhost:/no-exist";
            root = "./does_not_exist";
          }
        ];
      };
      systemd.services.scgi_server = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${scgi_server}/bin/scgi-server";
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
    geminiserver.wait_for_unit("scgi_server")
    geminiserver.wait_for_open_port(1099)
    geminiserver.wait_for_unit("stargazer")
    geminiserver.wait_for_open_port(1965)

    with subtest("stargazer test suite"):
      response = geminiserver.succeed("sh -c 'cd ${test_env}; ${test_script}/bin/test'")
      print(response)
  '';
}
