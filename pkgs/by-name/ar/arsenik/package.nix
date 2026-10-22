{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arsenik";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "arsenik";
    tag = finalAttrs.version;
    hash = "sha256-qY+SRWvZoy3iwsoZbzN5+TVWNIe3WWXkUGu/9MT20AU=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r kanata $out/share/arsenik

    runHook postInstall
  '';

  meta = {
    description = "33-key layout that works with all keyboards";
    homepage = "https://github.com/OneDeadKey/arsenik";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
