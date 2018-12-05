{ stdenv, autoPatchelfHook, lib, makeWrapper, requireFile,
ffmpeg_0_10,
glib,
pango,
cairo,
freetype,
fontconfig,
atk,
gdk_pixbuf,
gtk2,
libxslt,
libxml2,
libXtst,
libXxf86vm
}:

stdenv.mkDerivation rec {
  pname = "JavaSceneBuilder";
  version = "2_0";
  name = "${pname}-${version}";

  src = requireFile {
    name = "javafx_scenebuilder-${version}-linux-x64.tar.gz";
      sha256 = "0b66wxrg9n6i0ysvl4n07kj1d5zqk32vywxrvdn3spykn8pxixj4";
    message = ''
      SceneBuilder cannot be downloaded without license acception.
      1. Download a copy from https://www.oracle.com/technetwork/java/javase/downloads/javafxscenebuilder-1x-archive-2199384.html
      2. In a shell, execute:
         nix-prefetch-url file:///path/to/Xcode_7.2.dmg
     '';
  };

  buildInputs = [
    ffmpeg_0_10
    glib
    pango
    cairo
    freetype
    fontconfig
    atk
    gdk_pixbuf
    gtk2
    libxslt
    libxml2
    libXtst
    libXxf86vm autoPatchelfHook];

  unpackPhase = ''
    tar -xzf ${src}
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ./JavaFXSceneBuilder2.0/* $out
    ln -s $out/JavaFXSceneBuilder2.0 $out/bin
    autoPatchelf $out
    ls -lar $out
  '';



  meta = with lib; {
    description = "A Visual Layout Tool for JavaFX Applications";
    homepage = https://www.oracle.com/technetwork/java/javase/downloads/javafxscenebuilder-info-2157684.html;
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = [ maintainers.ysndr ];
  };
}
