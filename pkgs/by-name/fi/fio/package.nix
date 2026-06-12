{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "3.42";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    tag = "fio-${finalAttrs.version}";
    hash = "sha256-v2A2mY0Lvoje632761urfR7h1KHVcGnVDaKOMjexqis=";
  };

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
    changelog = "https://github.com/axboe/fio/releases/tag/${finalAttrs.src.tag}";
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    hasNoMaintainersButDependents = true;
  };
})
