{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "gandom-fonts";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "gandom-font";
    rev = "v${version}";
    hash = "sha256-nez8T0TtRLyXxIIR69LrVGde5ThCvA0fLXkYLyYQRV8=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/gandom-fonts {} \;

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rastikerdar/gandom-font";
    description = "Persian (Farsi) Font - فونت (قلم) فارسی گندم";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
