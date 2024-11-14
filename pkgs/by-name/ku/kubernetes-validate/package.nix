{
  lib,
  python3,
  runCommand,
  # configurable options
  extraPackages ? (ps: [ ]),
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.kubernetes-validate ] ++ extraPackages ps);
  kubernetes-validate = python3.pkgs.kubernetes-validate;
in
runCommand "kubernetes-validate-${kubernetes-validate.version}"
  {
    inherit (kubernetes-validate)
      pname
      version
      meta
      passthru
      ;
  }
  ''
    mkdir -p $out/bin
    for bin in ${lib.getBin kubernetes-validate}/bin/*; do
      ln -s ${pythonEnv}/bin/$(basename "$bin") $out/bin/
    done
  ''
