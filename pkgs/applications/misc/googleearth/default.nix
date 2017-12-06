{ stdenv, fetchurl, glibc, mesa, alsaLib, freetype, glib, libSM, libICE, libXi, libXv
, libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11
, qtbase, qtdeclarative, qtlocation, qtmultimedia, qtscript, qtsensors, qtsvg, qtwebchannel, qtwebkit, qtx11extras
, zlib, fontconfig, dpkg, makeWrapper }:

let
  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux"   = "i386";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  sha256 = {
    "x86_64-linux" = "05j4j93w64s3gzrp30v4h4sfcwbbndww7g9rkvg09c7rgkl374iw";
    "i686-linux"   = "16y3sv6cbg71r55kqdqj30szhgnsgk17jpf6j2w7qixl3n233z1b";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  libPath = stdenv.lib.makeLibraryPath [
    glibc
    glib
    stdenv.cc.cc
    libSM
    libICE
    libXi
    libXv
    mesa
    libX11
    libXcursor
    libXext
    libXfixes
    libXinerama
    libXrandr
    libXrender
    qtbase qtdeclarative qtlocation qtmultimedia qtscript qtsensors qtsvg qtwebchannel qtwebkit qtx11extras
    zlib
    alsaLib
    fontconfig freetype
  ];

in stdenv.mkDerivation rec {
  name = "googleearth-${version}";
  version = "7.3.0.3832";

  src = fetchurl {
    url = "https://dl.google.com/earth/client/current/google-earth-pro-stable_current_${arch}.deb";
    inherit sha256;
  };

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = false;

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    mkdir -p $out
    dpkg-deb -x ${src} $out
  '';

  installPhase =''
    runHook preInstall

    dir=$out/opt/google/earth/pro

    mv $out/usr/* $out/
    mv $dir/*.desktop $out/share/applications

    rmdir $out/{etc,usr}

    rm $out/bin/* $dir/google-earth-pro $dir/libQt*

    for f in $dir/googleearth-bin $dir/repair_tool ; do
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}:\$ORIGIN" \
        $f
    done

    for f in $dir/*.so* $dir/plugins/*.so $dir/plugins/**/*.so ; do
      chmod 755 $f # patchelf will bail without write permissions
      patchelf --set-rpath "${libPath}:\$ORIGIN" $f
    done

    for f in $out/share/applications/*.desktop ; do
      sed -i $f -e 's,Exec=.*,Exec=$out/bin/google-earth,g'
    done

    substituteInPlace $dir/qt.conf \
      --replace Plugins=plugins Plugins=$dir/plugins

    makeWrapper $dir/googleearth $out/bin/google-earth \
     --set LIBGL_DEBUG verbose

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A world sphere viewer";
    homepage    = https://earth.google.com;
    license     = licenses.unfree;
    maintainers = with maintainers; [ viric ];
    platforms   = platforms.linux;
  };
}
