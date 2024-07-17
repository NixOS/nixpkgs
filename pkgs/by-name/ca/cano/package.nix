{
  stdenv,
  lib,
  fetchFromGitHub,
  gnumake,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "cano";
  version = "0-unstable-2024-31-3";

  src = fetchFromGitHub {
    owner = "CobbCoding1";
    repo = "Cano";
    rev = "6b3488545b4180f20a7fa892fb0ee719e9298ddc";
    hash = "sha256-qFo0szZVGLUf7c7KdEIofcieWZqtM6kQE6D8afrZ+RU=";
  };

  buildInputs = [
    gnumake
    ncurses
  ];
  hardeningDisable = [
    "format"
    "fortify"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/cano $out/bin
  '';

  meta = {
    description = "Text Editor Written In C Using ncurses";
    homepage = "https://github.com/CobbCoding1/Cano";
    license = lib.licenses.asl20;
    mainProgram = "Cano";
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
  };
})
