{
  lib,
  stdenv,
  fetchFromGitHub,
  fontc,
}:

stdenv.mkDerivation rec {
  pname = "googlesans-code";
  version = "6.001";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "googlesans-code";
    tag = "v${version}";
    hash = "sha256-ScFx+uty9x+VTWxw7NJm3M7AYr0C00bdSnJJmFW3Jy0=";
  };

  nativeBuildInputs = [
    fontc
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p fonts/variable
    fontc sources/GoogleSansCode.glyphspackage --flatten-components --decompose-transformed-components --output-file "fonts/variable/GoogleSansCode[wght].ttf"
    fontc sources/GoogleSansCode-Italic.glyphspackage --flatten-components --decompose-transformed-components --output-file "fonts/variable/GoogleSansCode-Italic[wght].ttf"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/googlesans-code
    cp fonts/variable/* $out/share/fonts/googlesans-code/

    runHook postInstall
  '';

  meta = {
    description = "Google Sans Code font family";
    homepage = "https://github.com/googlefonts/googlesans-code";
    changelog = "https://github.com/googlefonts/googlesans-code/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ shiphan ];
    platforms = lib.platforms.all;
  };
}
