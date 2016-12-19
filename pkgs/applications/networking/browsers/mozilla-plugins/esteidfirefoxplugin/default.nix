{ stdenv, fetchurl, gtk2, openssl, pcsclite, pkgconfig, opensc }:

stdenv.mkDerivation rec {
  version = "3.12.1.1142";
  name = "esteidfirefoxplugin-${version}";

  src = fetchurl {
    url = "https://installer.id.ee/media/ubuntu/pool/main/e/esteidfirefoxplugin/esteidfirefoxplugin_3.12.1.1142.orig.tar.xz";
    sha256 = "0y7759x1xr00p5r3c5wpllcqqnnxh2zi74cmy4m9m690z3ywn0fx";
  };

  unpackPhase = ''
    mkdir src
    tar xf $src -C src
    cd src
  '';

  buildInputs = [ gtk2 openssl pcsclite pkgconfig opensc ];

  buildPhase = ''
    sed -i "s|opensc-pkcs11.so|${opensc}/lib/pkcs11/opensc-pkcs11.so|" Makefile 
    make plugin
  '';

  installPhase = ''
    plugins=$out/lib/mozilla/plugins
    mkdir -p $plugins
    cp -a npesteid-firefox-plugin.so $plugins/
    rp=$(patchelf --print-rpath $plugins/npesteid-firefox-plugin.so)
    patchelf --set-rpath "$rp:${opensc}/lib:${opensc}/lib/pkcs11" $plugins/npesteid-firefox-plugin.so
  '';

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Firefox ID card signing plugin";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
