{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "macfanctld";
  version = "f958bb1860f598ba92f9dc2880cad8892124099e";

  src = fetchFromGitHub {
    owner = "MikaelStrom";
    repo = "${finalAttrs.pname}";
    rev = "${finalAttrs.version}";
    hash = "sha256-O7ozlpO7uJaDPwl9FX3mB773HNnOguNeoVVZmlVRgWE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 macfanctld $out/bin/macfanctld

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/MikaelStrom/macfanctld";
    description = "Fan control for MacBook";
    maintainers = with lib.maintainers; [ inomish ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "macfanctld";
  };
})
