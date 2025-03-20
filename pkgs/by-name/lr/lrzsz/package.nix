{
  lib,
  stdenv,
  gettext,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "lrzsz";
  version = "0.12.20";

  src = fetchurl {
    url = "https://ohse.de/uwe/releases/lrzsz-${version}.tar.gz";
    sha256 = "1wcgfa9fsigf1gri74gq0pa7pyajk12m4z69x7ci9c6x9fqkd2y2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-10195.patch";
      url = "https://bugzilla.redhat.com/attachment.cgi?id=79507";
      sha256 = "0jlh8w0cjaz6k56f0h3a0h4wgc51axmrdn3mdspk7apjfzqcvx3c";
    })
  ];

  makeFlags = [ "AR:=$(AR)" ];

  nativeBuildInputs = [ gettext ];

  hardeningDisable = [ "format" ];

  configureFlags = [ "--program-transform-name=s/^l//" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=incompatible-pointer-types";

  meta = with lib; {
    homepage = "https://ohse.de/uwe/software/lrzsz.html";
    description = "Communication package providing the XMODEM, YMODEM ZMODEM file transfer protocols";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
