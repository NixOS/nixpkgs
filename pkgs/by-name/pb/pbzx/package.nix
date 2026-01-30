{
  lib,
  fetchFromGitHub,
  stdenv,
  xar,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pbzx";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "NiklasRosenstein";
    repo = "pbzx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ILG+K293rMUZ1S9yaEBlRDLmnVYG1jRuseFfaCs/jS8=";
  };

  patches = [ ./stdin.patch ];

  buildInputs = [
    xar
    xz
  ];

  buildPhase = ''
    runHook preBuild

    $CC pbzx.c -llzma -lxar -o pbzx

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin pbzx

    runHook postInstall
  '';

  meta = {
    description = "Stream parser of Apple's pbzx compression format";
    homepage = "https://github.com/NiklasRosenstein/pbzx";
    downloadPage = "https://github.com/NiklasRosenstein/pbzx/releases";
    changelog = "https://github.com/NiklasRosenstein/pbzx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "pbzx";
    platforms = lib.platforms.unix;
  };
})
