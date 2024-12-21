{
  lib,
  stdenv,
  fetchurl,
  sane-backends,
  libX11,
  gtk2,
  pkg-config,
  libusb-compat-0_1 ? null,
}:

stdenv.mkDerivation rec {
  pname = "sane-frontends";
  version = "1.0.14";

  src = fetchurl {
    url = "https://alioth-archive.debian.org/releases/sane/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1ad4zr7rcxpda8yzvfkq1rfjgx9nl6lan5a628wvpdbh3fn9v0z7";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/gtkglue.c
  '';

  buildInputs = [
    sane-backends
    libX11
    gtk2
  ] ++ lib.optional (libusb-compat-0_1 != null) libusb-compat-0_1;
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scanner Access Now Easy";
    homepage = "http://www.sane-project.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
