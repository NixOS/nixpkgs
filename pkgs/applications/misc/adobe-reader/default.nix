{
  lib,
  stdenv,
  fetchurl,
  libX11,
  cups,
  zlib,
  libxml2,
  pango,
  atk,
  gtk2,
  glib,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
}:

stdenv.mkDerivation rec {
  pname = "adobe-reader";
  version = "9.5.5";

  src = fetchurl {
    url = "http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/${version}/enu/AdbeRdr${version}-1_i486linux_enu.tar.bz2";
    sha256 = "0h35misxrqkl5zlmmvray1bqf4ywczkm89n9qw7d9arqbg3aj3pf";
  };

  # !!! Adobe Reader contains copies of OpenSSL, libcurl, and libicu.
  # We should probably remove those and use the regular Nixpkgs versions.
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libX11
    zlib
    libxml2
    cups
    pango
    atk
    gtk2
    glib
    gdk-pixbuf
    gdk-pixbuf-xlib
  ];

  installPhase = ''
    p=$out/libexec/adobe-reader
    mkdir -p $out/libexec
    tar xvf COMMON.TAR -C $out
    tar xvf ILINXR.TAR -C $out
    mv $out/Adobe/Reader9 $p
    rmdir $out/Adobe

    # Disable this plugin for now (it needs LDAP).
    rm $p/Reader/intellinux/plug_ins/PPKLite.api

    # Remove unneeded files
    rm $p/bin/UNINSTALL
  '';

  postFixup = ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $libPath \
        $p/Reader/intellinux/bin/acroread

    # The "xargs -r" is to shut up a warning when Mozilla can't be found.
    substituteInPlace $p/bin/acroread \
        --replace-fail /bin/pwd $(type -P pwd) \
        --replace-fail /bin/ls $(type -P ls) \
        --replace-fail xargs "xargs -r"

    mkdir -p $out/bin
    ln -s $p/bin/acroread $out/bin/acroread

    mkdir -p $out/share/applications
    mv $p/Resource/Support/AdobeReader.desktop $out/share/applications/
    icon=$p/Resource/Icons/128x128/AdobeReader9.png
    [ -e $icon ]
    sed -i $out/share/applications/AdobeReader.desktop \
        -e "s|Icon=.*|Icon=$icon|"

    mkdir -p $out/share/mimelnk/application
    mv $p/Resource/Support/vnd*.desktop $out/share/mimelnk/application
  '';

  dontStrip = true;

  passthru.mozillaPlugin = "/libexec/adobe-reader/Browser/intellinux";

  meta = {
    description = "Adobe Reader, a viewer for PDF documents";
    homepage = "http://www.adobe.com/products/reader";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    knownVulnerabilities = [
      "Numerous unresolved vulnerabilities"
      "See: https://www.cvedetails.com/product/497/Adobe-Acrobat-Reader.html?vendor_id=53"
    ];
    platforms = [ "i686-linux" ];
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "acroread";
  };
}
