{ runCommand, stdenv, ... }:

let
  args = [ "a%Nything" "lang=\${LANG}" ";" "/bin/sh -c date" { substitute = "%i \${ENV}"; } ];
  module = {
    boot.isContainer = true;
    systemd.services.echo = {
      startCommands = [{
        script = ''
          for s in "$@"; do
            printf '%s\n' "$s"
          done
        '';
        inherit args;
      }];
    };
  };
  eval = import ../lib/eval-config.nix {
    system = stdenv.hostPlatform.system;
    modules = [ module ];
  };
in

runCommand "systemd-escaping" {
  expected = ''script  "a%%Nything" "lang=''$''${LANG}" ";" "/bin/sh -c date" %i ''${ENV}'';
} ''
  grep -qF "$expected" < ${eval.config.system.build.units."echo.service".unit}/echo.service
  touch $out
''
