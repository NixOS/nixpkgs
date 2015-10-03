{ stdenv, fetchurl, cairo, colord, glib, gtk3, gusb, intltool, itstool, libusb
, libxml2, makeWrapper, packagekit, pkgconfig, saneBackends, systemd, vala }:

let version = "3.18.0"; in
stdenv.mkDerivation rec {
  name = "simple-scan-${version}";

  src = fetchurl {
    sha256 = "09qki4h1px65fxwpr7jppzqsi5cfcb8168p13blp3wcfizjgb9gl";
    url = "https://launchpad.net/simple-scan/3.18/${version}/+download/${name}.tar.xz";
  };

  buildInputs = [ cairo colord glib gusb gtk3 libusb libxml2 packagekit
    saneBackends systemd vala ];
  nativeBuildInputs = [ intltool itstool makeWrapper pkgconfig ];

  enableParallelBuilding = true;

  doCheck = true;

  preFixup = ''
    wrapProgram "$out/bin/simple-scan" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    inherit version;
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
