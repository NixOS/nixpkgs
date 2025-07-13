{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "060102";
  pname = "fondu";

  src = fetchurl {
    url = "https://fondu.sourceforge.net/fondu_src-${version}.tgz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace /System/Library/Frameworks/CoreServices.framework/CoreServices "-framework CoreServices"
  '';

  makeFlags = [ "DESTDIR=$(out)" ];

  hardeningDisable = [ "fortify" ];

  meta = {
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
  };
}
