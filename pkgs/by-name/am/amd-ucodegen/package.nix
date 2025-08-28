{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amd-ucodegen";
  version = "0-unstable-2017-06-07";

  src = fetchFromGitHub {
    owner = "AndyLavr";
    repo = "amd-ucodegen";
    rev = "0d34b54e396ef300d0364817e763d2c7d1ffff02";
    hash = "sha256-pgmxzd8tLqdQ8Kmmhl05C5tMlCByosSrwx2QpBu3UB0=";
  };

  strictDeps = true;

  patches = [
    # Extract get_family function and validate processor family
    # instead of processor ID
    (fetchpatch {
      name = "validate-family-not-id.patch";
      url = "https://github.com/AndyLavr/amd-ucodegen/compare/0d34b54e396ef300d0364817e763d2c7d1ffff02...dobo90:amd-ucodegen:7a3c51e821df96910ecb05b22f3e4866b4fb85b2.patch";
      hash = "sha256-jvsvu9QgXikwsxjPiTaRff+cOg/YQmKg1MYKyBoMRQI=";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 amd-ucodegen $out/bin/amd-ucodegen

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    tests.platomav = callPackage ./test-platomav.nix { amd-ucodegen = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Tool to generate AMD microcode files";
    longDescription = ''
      This tool can be used to generate AMD microcode containers as used by the
      Linux kernel. It accepts raw AMD microcode files such as those generated
      by [MCExtractor](https://github.com/platomav/MCExtractor.git) as input.
      The generated output file can be installed in /lib/firmware/amd-ucode.
    '';
    homepage = "https://github.com/AndyLavr/amd-ucodegen";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "amd-ucodegen";
    maintainers = with lib.maintainers; [ d-brasher ];
  };
})
