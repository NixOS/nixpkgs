{
  lib,
  stdenv,
  fetchFromGitHub,
  raylib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ap-visual-sorting";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cedric-star";
    repo = "ap-visual-sorting";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DEIN-HASH-HIER=";
  };

  __structuredAttrs = true; # NPV-166
  strictDeps = true; # NPV-164

  buildInputs = [ raylib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp MySorter $out/bin/ap-visual-sorting
    runHook postInstall
  '';

  meta = {
    description = "Visualize sorting algorithms written in C";
    homepage = "https://github.com/cedric-star/ap-visual-sorting";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ap-visual-sorting";
    platforms = lib.platforms.linux;
  };
})
