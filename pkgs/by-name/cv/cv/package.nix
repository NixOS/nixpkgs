{
  lib,
  php,
  stdenv,
  fetchurl,
  writeShellScriptBin,
}:
let
  phar = stdenv.mkDerivation rec {
    name = "cv";
    version = "0.3.65";
    src = fetchurl {
      url = "https://download.civicrm.org/cv/cv-${version}.phar";
      hash = "sha256-4ILEWqx6PDvPM07DdFetBrRwqlOs3kIHNibc8jc78OE=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      cp -ra $src $out
    '';
  };
in
(writeShellScriptBin "cv" ''
  ${php}/bin/php ${phar} $@
'').overrideAttrs
  (oldAttrs: {
    version = phar.version;

    meta = with lib; {
      homepage = "https://civicrm.org/";
      changelog = "https://github.com/civicrm/cv/releases/tag/v${version}";
      description = "CiviCRM CLI Utility";
      license = lib.licenses.agpl3Plus;
      maintainers = [ lib.maintainers.b12f ];
    };
  })
