{
  lib,
  stdenv,
  fetchurl,
  php,
  which,
  makeWrapper,
  gnumake,
  gcc,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phoronix-test-suite";
  version = "10.8.4";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/phoronix-test-suite-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HyCS1TbAoxk+/FPkpQ887mXA7xp40x5UBPHGY//3t/Q=";
  };

  buildInputs = [ php ];
  nativeBuildInputs = [
    which
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    ./install-sh $out
    wrapProgram $out/bin/phoronix-test-suite \
    --set PHP_BIN ${php}/bin/php \
    --prefix PATH : ${
      lib.makeBinPath [
        gnumake
        gcc
      ]
    }

    runHook postInstall
  '';

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = {
    description = "Open-Source, Automated Benchmarking";
    homepage = "https://www.phoronix-test-suite.com/";
    maintainers = with lib.maintainers; [ davidak ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
    mainProgram = "phoronix-test-suite";
  };
})
