{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitterentropy-rngd";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-rngd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iXpeN0PAPk8mcaNXwj6TlyK57NSFNOVs/XmEmUG1gIg=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    make install DESTDIR= PREFIX=$out UNITDIR=$out/lib/systemd/system

    runHook postInstall
  '';

  # this package internally compiles without optimization by choice,
  # as it introduces more execution time jitter, therefore disable fortify.
  hardeningDisable = [
    "fortify"
    "fortify3"
  ];

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
