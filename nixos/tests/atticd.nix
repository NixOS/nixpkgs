{ lib, pkgs, ... }:

let
  environmentFile = pkgs.runCommand "atticd-env" { } ''
    echo ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="$(${lib.getExe pkgs.openssl} genrsa -traditional 4096 | ${pkgs.coreutils}/bin/base64 -w0)" > $out
  '';
in

{
  name = "atticd";

  nodes.machine = {
    services.atticd = {
      enable = true;

      inherit environmentFile;
    };
  };

  testScript = # python
    ''
      start_all()
      machine.wait_for_unit("atticd.service")

      token = machine.succeed("atticd-atticadm make-token --sub stop --validity 1y --create-cache '*' --pull '*' --push '*' --delete '*' --configure-cache '*' --configure-cache-retention '*'").strip()

      machine.succeed(f"attic login local http://localhost:8080 {token}")
      machine.succeed("attic cache create test-cache")
      machine.succeed("attic push test-cache ${environmentFile}")
    '';
}
