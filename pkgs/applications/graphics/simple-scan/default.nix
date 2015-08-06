{ stdenv, fetchurl, cairo, colord, glib, gtk3, intltool, itstool, libxml2
, makeWrapper, pkgconfig, saneBackends, systemd, vala, lcms }:

let version = "3.17.4"; in
stdenv.mkDerivation rec {
  name = "simple-scan-${version}";

  src = fetchurl {
    sha256 = "1pslbv45g01g039zj2b01k08f763kkhzqw8wwz7yh27m7bjllnx6";
    url = "https://launchpad.net/simple-scan/3.17/${version}/+download/${name}.tar.xz";
  };

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
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ cairo colord glib gtk3 libxml2
    saneBackends systemd vala lcms ];
  nativeBuildInputs = [ intltool itstool makeWrapper pkgconfig ];

  enableParallelBuilding = true;

  doCheck = true;

  preFixup = ''
    wrapProgram "$out/bin/simple-scan" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';
}
