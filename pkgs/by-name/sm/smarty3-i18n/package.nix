{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smarty-i18n";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "kikimosha";
    repo = "smarty3-i18n";
    rev = finalAttrs.version;
    sha256 = "0rjxq4wka73ayna3hb5dxc5pgc8bw8p5fy507yc6cv2pl4h4nji2";
  };

  installPhase = ''
    mkdir $out
    cp block.t.php $out
  '';

  meta = {
    description = "gettext for the smarty3 framework";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/kikimosha/smarty3-i18n";
    maintainers = with lib.maintainers; [ das_j ];
    platforms = lib.platforms.all;
  };
})
