{
  lib,
  stdenv,
  fetchFromGitHub,
  fontc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "googlesans-code";
  version = "7.000";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "googlesans-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XjsjBMCA1RraXhQiNq/D0mb//VnRKOWl1X4XpGzifNA=";
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
    changelog = "https://github.com/googlefonts/googlesans-code/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ shiphan ];
    platforms = lib.platforms.all;
  };
})
