{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mno16";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/sevmeyer/mno16/releases/download/${version}/mno16-${version}.zip";
    stripRoot = false;
    hash = "sha256-xJQ9V7GlGUTEeYhqYFl/SemS6iqV0eW85YOn/tLgA+M=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp fonts/*.ttf $out/share/fonts/truetype/
  '';

  meta = {
    description = "Minimalist monospaced font";
    homepage = "https://sev.dev/fonts/mno16";
    license = lib.licenses.cc0;
  };
}
