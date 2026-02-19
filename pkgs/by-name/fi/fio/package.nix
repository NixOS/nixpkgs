{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "fio";
  version = "3.41";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    rev = "fio-${finalAttrs.version}";
    sha256 = "sha256-m4JskjSc/KHjID+6j/hbhnGzehPxMxA3m2Iyn49bJDU=";
  };

  patches = [
    # https://github.com/axboe/fio/pull/2029
    (fetchpatch {
      url = "https://github.com/axboe/fio/commit/ccce76d2850d6e52da3d7986c950af068fbfe0fd.patch";
      hash = "sha256-0jN3q1vTiU6YkdXrcTAOzqRqgu8sW8AWO4KkANi0XKo=";
    })
  ];

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
    wrapPythonProgramsIn "$out/bin" "$out ''${pythonPath[*]}"
  '';

  meta = {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
