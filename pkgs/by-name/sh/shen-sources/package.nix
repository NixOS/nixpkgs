{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "shen-sources";
  version = "22.4";

  src = fetchurl {
    url = "https://github.com/Shen-Language/shen-sources/releases/download/shen-${version}/ShenOSKernel-${version}.tar.gz";
    sha256 = "1wlyh4rbzr615iykq1s779jvq28812rb4dascx1kzpakhw8z0260";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp . $out -R
  '';

  meta = {
    homepage = "https://shenlanguage.org";
    description = "Source code for the Shen Language";
    changelog = "https://github.com/Shen-Language/shen-sources/raw/shen-${version}/CHANGELOG.md";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bsima ];
    license = lib.licenses.bsd3;
  };
}
