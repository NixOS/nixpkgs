{ stdenv, fetchurl, cairo, colord, glib, gtk3, gusb, intltool, itstool
, libusb1, libxml2, pkgconfig, sane-backends, vala, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "simple-scan-${version}";
  version = "3.19.92";

  src = fetchurl {
    sha256 = "1zz6y4cih1v0npxjfxvnqz3bz7i5aripdsfy0hg9mhr1f4r0ig19";
    url = "https://launchpad.net/simple-scan/3.19/${version}/+download/${name}.tar.xz";
  };

  buildInputs = [ cairo colord glib gusb gtk3 libusb1 libxml2 sane-backends
    vala ];
  nativeBuildInputs = [ intltool itstool pkgconfig wrapGAppsHook ];

  configureFlags = [ "--disable-packagekit" ];

  preBuild = ''
    # Clean up stale .c files referencing packagekit headers as of 3.19.91:
    make clean
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Simple scanning utility";
    longDescription = ''
      A really easy way to scan both documents and photos. You can crop out the
      bad parts of a photo and rotate it if it is the wrong way round. You can
      print your scans, export them to pdf, or save them in a range of image
      formats. Basically a frontend for SANE - which is the same backend as
      XSANE uses. This means that all existing scanners will work and the
      interface is well tested.
    '';
    homepage = https://launchpad.net/simple-scan;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
