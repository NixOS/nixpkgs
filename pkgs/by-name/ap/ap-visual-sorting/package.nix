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
    hash = "sha256-SPUfhQD4i04W3Om/qhcDGSs0/0qzv5EyijU43EovyZo="; # placeholder
  };

  buildInputs = [ raylib ];

  # Falls dein Makefile kein PREFIX/DESTDIR unterstützt:
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

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
    maintainers = with lib.maintainers; [ ]; # deinen GitHub-Namen hier, nach PR
    mainProgram = "ap-visual-sorting";
    platforms = lib.platforms.linux; # raylib hat Einschränkungen
  };
})