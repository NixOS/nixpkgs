{stdenv, fetchurl, which, pkgconfig, file, glib, gtk2, gtk3, curl, libXt}:
let
  srcData = # Generated upstream information 
  rec {
    baseName="nspluginwrapper";
    version="1.4.4";
    name="${baseName}-${version}";
    hash="1fxjz9ifhw0drm12havlsl4jpsq1nv930gqa005kgddv5pa99vgj";
    url="http://nspluginwrapper.org/download/nspluginwrapper-1.4.4.tar.gz";
  };
in
stdenv.mkDerivation rec {
  inherit (srcData) name version;

  src = fetchurl{
    inherit (srcData) url;
    sha256 = srcData.hash;
  };

  preConfigure = ''
    sed -e 's@/usr/bin/@@g' -i configure
    sed -e '/gthread[.]h/d' -i src/npw-player.c
    export NIX_LDFLAGS="$NIX_LDFLAGS -lgthread-2.0"
    export configureFlags="$configureFlags --target-cpu=$(uname -m)"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [which file glib gtk2 gtk3 curl libXt];

  preferLocalBuild = true;

  meta = {
    description = ''A wrapper to run browser plugins out-of-process'';
    homepage = http://nspluginwrapper.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x64_64-linux" "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.raskin ];
    inherit (srcData) version;
  };
}
