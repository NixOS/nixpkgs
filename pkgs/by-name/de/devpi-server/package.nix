{
  lib,
  python3,
  runCommand,
  # configurable options
  extraPackages ? (ps: [ ]),
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.devpi-server ] ++ extraPackages ps);
  server = python3.pkgs.devpi-server;
in
runCommand "devpi-${server.version}"
  {
    inherit (server)
      pname
      version
      meta
      passthru
      ;
  }
  ''
    mkdir -p $out/bin
    for bin in ${lib.getBin server}/bin/*; do
      ln -s ${pythonEnv}/bin/$(basename "$bin") $out/bin/
    done
  ''
