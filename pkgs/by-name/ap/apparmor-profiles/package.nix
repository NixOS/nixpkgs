{
  stdenv,
  which,
  callPackage,

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

  checkInputs = [
    apparmor-parser
    apparmor-utils
  ];

  preCheck = ''
    export USE_SYSTEM=1
    export LOGPROF="aa-logprof --configdir ${callPackage ./test_config.nix { }} --no-check-mountpoint"
  '';

  doCheck = true;

  meta = libapparmor.meta // {
    description = "Mandatory access control system - profiles";
    mainProgram = "apparmor_parser";
  };
}
