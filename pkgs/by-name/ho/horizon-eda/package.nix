{
  stdenv,
  boost,
  callPackage,
  coreutils,
  libspnav,
  python3,
  wrapGAppsHook3,
}:

let
  base = callPackage ./base.nix { };
in
stdenv.mkDerivation rec {
  inherit (base)
    pname
    version
    src
    meta
    CASROOT
    env
    ;

  # provide base for python module
  passthru = {
    inherit base;
  };

  buildInputs = base.buildInputs ++ [
    libspnav
  ];

  nativeBuildInputs = base.nativeBuildInputs ++ [
    boost.dev
    wrapGAppsHook3
    python3
  ];

  installFlags = [
    "INSTALL=${coreutils}/bin/install"
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  enableParallelBuilding = true;
}
