{
  stdenv,
  buildPackages,
  fetchurl,
  popt,
  ncurses,
  python3,
  readline,
  lib,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  version = "2.0.37";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "sha256-xi049dp99Cmaw6ZSUI6VlTd1JEAYHjTHayrs69fzAbk=";
  };

  postConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace lanserv/Makefile \
      --replace-fail "sdrcomp/sdrcomp_build -o" "${buildPackages.openipmi}/bin/sdrcomp -o"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    ncurses
    popt
    python3
    readline
    openssl
  ];

  makeFlags = [
    "BUILD_CC=${stdenv.cc.targetPrefix}cc"
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  meta = with lib; {
    homepage = "https://openipmi.sourceforge.io/";
    description = "User-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with licenses; [
      gpl2Only
      lgpl2Only
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arezvov ];
  };
}
