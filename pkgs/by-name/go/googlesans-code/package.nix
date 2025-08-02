{
  lib,
  stdenv,
  fetchFromGitHub,
  fontc,
}:

stdenv.mkDerivation rec {
  pname = "googlesans-code";
  version = "6.000";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "googlesans-code";
    rev = "v${version}";
    hash = "sha256-FPpxJGsx1uAen2QKhJmVBpFIlQk3ObieeZdrWIAR+oQ=";
  };

  nativeBuildInputs = [
    fontc
  ];

  buildPhase = ''
    mkdir -p fonts/variable
    fontc sources/GoogleSansCode.glyphspackage --flatten-components --decompose-transformed-components --output-file "fonts/variable/GoogleSansCode[wght].ttf"
    fontc sources/GoogleSansCode-Italic.glyphspackage --flatten-components --decompose-transformed-components --output-file "fonts/variable/GoogleSansCode-Italic[wght].ttf"
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/googlesans-code
    cp fonts/variable/* $out/share/fonts/googlesans-code/
  '';

  meta = {
    description = "The Google Sans Code font family";
    homepage = "https://github.com/googlefonts/googlesans-code";
    changelog = "https://github.com/googlefonts/googlesans-code/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ shiphan ];
    platforms = lib.platforms.all;
  };
}
