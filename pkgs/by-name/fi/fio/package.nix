{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  libaio,
  pkg-config,
  cunit,
  python3,
  zlib,
  withGnuplot ? false,
  gnuplot,
  withLibnbd ? stdenv.hostPlatform.isLinux,
  libnbd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fio";
  version = "3.41";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    tag = "fio-${finalAttrs.version}";
    hash = "sha256-m4JskjSc/KHjID+6j/hbhnGzehPxMxA3m2Iyn49bJDU=";
  };

  patches = [
    # https://github.com/axboe/fio/pull/2029
    (fetchpatch {
      url = "https://github.com/axboe/fio/commit/ccce76d2850d6e52da3d7986c950af068fbfe0fd.patch";
      hash = "sha256-0jN3q1vTiU6YkdXrcTAOzqRqgu8sW8AWO4KkANi0XKo=";
    })
  ];

  buildInputs = [
    cunit
    python3
    zlib
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libaio
  ++ lib.optional withLibnbd libnbd;

  # ./configure does not support autoconf-style --build=/--host=.
  # We use $CC instead.
  configurePlatforms = [ ];

  configureFlags = [
    "--disable-native"
  ]
  ++ lib.optional withLibnbd "--enable-libnbd";

  dontAddStaticConfigureFlags = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3.pkgs.wrapPython
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace tools/plot/fio2gnuplot \
      --replace-fail /usr/share/fio $out/share/fio
  '';

  pythonPath = [ python3.pkgs.six ];

  makeWrapperArgs = lib.optionals withGnuplot [
    "--prefix PATH : ${lib.makeBinPath [ gnuplot ]}"
  ];

  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out ''${pythonPath[*]}"
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./unittests/unittest

    runHook postCheck
  '';

  meta = {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
