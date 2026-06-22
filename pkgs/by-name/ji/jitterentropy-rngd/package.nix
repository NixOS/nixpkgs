{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitterentropy-rngd";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-rngd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iXpeN0PAPk8mcaNXwj6TlyK57NSFNOVs/XmEmUG1gIg=";
  };

  patches = [
    # Allow the systemd service to mlock the daemon's entropy buffer.
    (fetchpatch {
      url = "https://github.com/smuellerDD/jitterentropy-rngd/compare/v1.3.1...cee0c7a035e9564d161053012c6ea36b2ce27383.patch";
      hash = "sha256-zwcY9z9EikrhxZa39p4+gl+/EeZ4sAKaItQfrL1DFSo=";
    })
  ];

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
    changelog = "https://github.com/smuellerDD/jitterentropy-rngd/releases/tag/${finalAttrs.src.tag}";
    license = [
      lib.licenses.gpl2Only
      lib.licenses.bsd3
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thillux ];
    mainProgram = "jitterentropy-rngd";
  };
})
