{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "martian-mono";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/evilmartians/mono/releases/download/v${finalAttrs.version}/martian-mono-${finalAttrs.version}-otf.zip";
    sha256 = "sha256-W6ewNtFDS1O1fwoAe27tIgNZn7AAKo965dWkZYzsg+o=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ *.otf

    runHook postInstall
  '';

  meta = {
    description = "Free and open-source monospaced font from Evil Martians";
    homepage = "https://github.com/evilmartians/mono";
    changelog = "https://github.com/evilmartians/mono/raw/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
