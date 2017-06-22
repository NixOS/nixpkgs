{ stdenv, fetchurl, cairo, colord, glib, gtk3, gusb, intltool, itstool
, libusb1, libxml2, pkgconfig, sane-backends, vala_0_32, wrapGAppsHook
, gnome3 }:

stdenv.mkDerivation rec {
  name = "simple-scan-${version}";
  version = "${major_version}.0.1";
  major_version = "3.22";

  src = fetchurl {
    url = "https://launchpad.net/simple-scan/${major_version}/${version}/+download/${name}.tar.xz";
    sha256 = "0l1b3llkdlqq0bcjx1cadba67l2zb4zfykdaprpjbjbr6gkbc1f5";
  };

  buildInputs = [ cairo colord glib gnome3.defaultIconTheme gusb gtk3 libusb1 libxml2 sane-backends vala_0_32 ];
  nativeBuildInputs = [ intltool itstool pkgconfig wrapGAppsHook ];

  configureFlags = [ "--disable-packagekit" ];

  patchPhase = ''
    sed -i -e 's#Icon=scanner#Icon=simple-scan#g' ./data/simple-scan.desktop.in
  '';

  preBuild = ''
    # Clean up stale .c files referencing packagekit headers as of 3.20.0:
    make clean
  '';

  postInstall = ''
    mkdir -p $out/share/icons
    mv $out/share/simple-scan/icons/* $out/share/icons/
    (
    cd ${gnome3.defaultIconTheme}/share/icons/Adwaita
    for f in `find . | grep 'scanner\.'`
    do
      local outFile="`echo "$out/share/icons/hicolor/$f" | sed \
        -e 's#/devices/#/apps/#g' \
        -e 's#scanner\.#simple-scan\.#g'`"
      mkdir -p "`realpath -m "$outFile/.."`"
      cp "$f" "$outFile"
    done
    )
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
