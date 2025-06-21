{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "martian-grotesk";
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/evilmartians/grotesk/releases/download/v${version}/martian-grotesk-${version}-otf.zip";
    sha256 = "sha256-rYOSvjKjO7Lc84n7WXKPfwkuTSG2fAFU1c3hSeCXD7o=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ ./otf/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Free and open-source variable sans-serif font from Evil Martians";
    homepage = "https://github.com/evilmartians/grotesk";
    changelog = "https://github.com/evilmartians/grotesk/raw/v${version}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
