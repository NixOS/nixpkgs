{
  lib,
  stdenv,
  which,
  callPackage,
  python3,

  # apparmor deps
  libapparmor,
  apparmor-parser,
  apparmor-utils,
}:
stdenv.mkDerivation {
  pname = "apparmor-profiles";
  inherit (libapparmor) version src;

  sourceRoot = "${libapparmor.src.name}/profiles";

  nativeBuildInputs = [ which ];

  installFlags = [
    "DESTDIR=$(out)"
    "EXTRAS_DEST=$(out)/share/apparmor/extra-profiles"
  ];

  checkTarget = "check";

  nativeCheckInputs = [
    apparmor-parser
    apparmor-utils
  ];

  checkInputs = [
    python3
  ];

  preCheck = ''
    export USE_SYSTEM=1
    export LOGPROF="aa-logprof --configdir ${callPackage ./test_config.nix { }} --no-check-mountpoint"
    patchShebangs ../parser/tst
    substituteInPlace ../parser/tst/test_profile.py \
      --replace-fail '../parser/apparmor_parser' '${lib.getExe apparmor-parser}'
  '';

  doCheck = true;
  strictDeps = true;

  meta = libapparmor.meta // {
    description = "Mandatory access control system - profiles";
    mainProgram = "apparmor_parser";
  };
}
