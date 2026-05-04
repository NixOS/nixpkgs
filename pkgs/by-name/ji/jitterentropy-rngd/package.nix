{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitterentropy-rngd";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-rngd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PadDqDemklNbyi3VMkvPNMYN185YZYwrUar7KyXOJrc=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    make install DESTDIR= PREFIX=$out UNITDIR=$out/lib/systemd/system

    runHook postInstall
  '';

  meta = {
    description = "Random number generator, which injects entropy to the kernel";
    homepage = "https://github.com/smuellerDD/jitterentropy-rngd";
    changelog = "https://github.com/smuellerDD/jitterentropy-rngd/releases/tag/v${finalAttrs.version}";
    license = [
      lib.licenses.gpl2Only
      lib.licenses.bsd3
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thillux ];
    mainProgram = "jitterentropy-rngd";
  };
})
