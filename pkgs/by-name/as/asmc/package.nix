{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asmc";
  version = "2.36.02-unstable-2024-11-01";

  src = fetchFromGitHub {
    owner = "nidud";
    repo = "asmc";
    rev = "7dda9a180031c3723e270e0b6f51f4d8b73004a9";
    hash = "sha256-Uk9K8m8r9stetIlUoVfBlayeDZSDvt1EmTI68W8dwso=";
  };

  makeFlags = [
    "-C"
    "source/asmc"
    # Fails to build with the PIE default, sadly.
    "pic-default=no"
  ];

  hardeningDisable = [ "pie" ];

  # Lots of undeclared dependencies.
  enableParallelBuilding = false;

  postPatch = ''
    # Unconditionally passes `-Wl,-pie` even when PIC is disabled, and
    # then fails to build with it.
    substituteInPlace source/asmc/makefile \
      --replace-fail 'gcc -Wl,-pie' gcc
  '';

  # `make install` hard‐codes `/usr` and `sudo`; not worth it.
  #
  # This doesn’t handle the include or library directories because we
  # just use this for `_7zz` and don’t install any of the libraries.
  # Better to fail fast if anyone needs them so they know they’ll need
  # to adjust this derivation.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp source/asmc/{asmc,asmc64} $out/bin

    runHook postInstall
  '';

  meta = {
    description = "MASM‐compatible assembler";
    homepage = "https://github.com/nidud/asmc";
    changelog = "https://github.com/nidud/asmc/blob/${finalAttrs.src.rev}/source/asmc/history.txt";
    license = lib.licenses.gpl2Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.jk ];
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isx86 lib.systems.inspect.patterns.isLinux;
  };
})
