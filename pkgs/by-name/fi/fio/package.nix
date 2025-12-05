{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  libaio,
  pkg-config,
  python3,
  zlib,
  withGnuplot ? false,
  gnuplot,
  withLibnbd ? true,
  libnbd,
}:

stdenv.mkDerivation rec {
  pname = "fio";
  version = "3.41";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${version}";
    sha256 = "sha256-m4JskjSc/KHjID+6j/hbhnGzehPxMxA3m2Iyn49bJDU=";
  };

  buildInputs = [
    python3
    zlib
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libaio
  ++ lib.optional withLibnbd libnbd;

  # ./configure does not support autoconf-style --build=/--host=.
  # We use $CC instead.
  configurePlatforms = [ ];

  configureFlags = lib.optional withLibnbd "--enable-libnbd";

  dontAddStaticConfigureFlags = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3.pkgs.wrapPython
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "mandir = /usr/share/man" "mandir = \$(prefix)/man" \
      --replace "sharedir = /usr/share/fio" "sharedir = \$(prefix)/share/fio"
    substituteInPlace tools/plot/fio2gnuplot --replace /usr/share/fio $out/share/fio
  '';

  pythonPath = [ python3.pkgs.six ];

  makeWrapperArgs = lib.optionals withGnuplot [
    "--prefix PATH : ${lib.makeBinPath [ gnuplot ]}"
  ];

  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
