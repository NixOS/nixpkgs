{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "jitterentropy-rngd";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LDym636ss3B1G/vrqatu9g5vbVEeDX0JQcxZ/IxGeY0=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    make install DESTDIR= PREFIX=$out UNITDIR=$out/lib/systemd/system

    runHook postInstall
  '';

  meta = {
    description = ''A random number generator, which injects entropy to the kernel'';
    homepage = "https://github.com/smuellerDD/jitterentropy-rngd";
    changelog = "https://github.com/smuellerDD/jitterentropy-rngd/releases/tag/v${version}";
    license = with lib.licenses; [
      gpl2Only
      bsd3
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thillux ];
    mainProgram = "jitterentropy-rngd";
  };
}
