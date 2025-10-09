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

stdenv.mkDerivation rec {
  pname = "phoronix-test-suite";
  version = "10.8.4";

  src = fetchurl {
    url = "https://phoronix-test-suite.com/releases/phoronix-test-suite-${version}.tar.gz";
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

  meta = with lib; {
    description = "Open-Source, Automated Benchmarking";
    homepage = "https://www.phoronix-test-suite.com/";
    maintainers = with maintainers; [ davidak ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
    mainProgram = "phoronix-test-suite";
  };
}
