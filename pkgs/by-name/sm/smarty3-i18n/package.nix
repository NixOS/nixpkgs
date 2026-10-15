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
    hash = "sha256-IkpLIKFXbGaYP6B4Vy7iC7F3C+utLDiU9WocNTnBXWY=";
  };

  installPhase = ''
    mkdir $out
    cp block.t.php $out
  '';

  meta = {
    description = "gettext for the smarty3 framework";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/kikimosha/smarty3-i18n";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
