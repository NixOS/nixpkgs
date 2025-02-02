{
  fetchurl,
  fontconfig,
  freetype,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  jdk17,
  lib,
  libX11,
  libXrender,
  libXtst,
  makeDesktopItem,
  makeWrapper,
  shared-mime-info,
  stdenv,
  unzip,
  webkitgtk_4_0,
  zlib,
}:

let
  pVersion = "1.15.0.20231206";
  pVersionTriple = lib.splitVersion pVersion;
  majorVersion = lib.elemAt pVersionTriple 0;
  minorVersion = lib.elemAt pVersionTriple 1;
  patchVersion = lib.elemAt pVersionTriple 2;
  baseVersion = "${majorVersion}.${minorVersion}.${patchVersion}";
  jdk = jdk17;
in
stdenv.mkDerivation rec {
  pname = "eclipse-mat";
  version = pVersion;

  src = fetchurl {
    url = "http://ftp.halifax.rwth-aachen.de/eclipse//mat/${baseVersion}/rcp/MemoryAnalyzer-${version}-linux.gtk.x86_64.zip";
    sha256 = "sha256-icmo5zdK0XaH32kXwZUVaQ0VPSGEgvlLr7v7PtdbmCg=";
  };

  desktopItem = makeDesktopItem {
    name = "eclipse-mat";
    exec = "eclipse-mat";
    icon = "eclipse";
    comment = "Eclipse Memory Analyzer";
    desktopName = "Eclipse MAT";
    genericName = "Java Memory Analyzer";
    categories = [ "Development" ];
  };

  unpackPhase = ''
    unzip $src
  '';

  buildCommand = ''
    mkdir -p $out
    unzip $src
    mv mat $out

    # Patch binaries.
    interpreter=$(echo ${stdenv.cc.libc}/lib/ld-linux*.so.2)
    libCairo=$out/eclipse/libcairo-swt.so
    patchelf --set-interpreter $interpreter $out/mat/MemoryAnalyzer
    [ -f $libCairo ] && patchelf --set-rpath ${
      lib.makeLibraryPath [
        freetype
        fontconfig
        libX11
        libXrender
        zlib
      ]
    } $libCairo

    # Create wrapper script.  Pass -configuration to store settings in ~/.eclipse-mat/<version>
    makeWrapper $out/mat/MemoryAnalyzer $out/bin/eclipse-mat \
      --prefix PATH : ${jdk}/bin \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath ([
          glib
          gtk3
          libXtst
          webkitgtk_4_0
        ])
      } \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-configuration \$HOME/.eclipse-mat/''${version}/configuration"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    find $out/mat/plugins -name 'eclipse*.png' -type f -exec cp {} $out/share/pixmaps \;
    mv $out/share/pixmaps/eclipse64.png $out/share/pixmaps/eclipse.png
  '';

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];
  buildInputs = [
    fontconfig
    freetype
    glib
    gsettings-desktop-schemas
    gtk3
    jdk
    libX11
    libXrender
    libXtst
    zlib
    shared-mime-info
    webkitgtk_4_0
  ];

  dontBuild = true;
  dontConfigure = true;

  meta = with lib; {
    description = "Fast and feature-rich Java heap analyzer";
    mainProgram = "eclipse-mat";
    longDescription = ''
      The Eclipse Memory Analyzer is a tool that helps you find memory
      leaks and reduce memory consumption. Use the Memory Analyzer to
      analyze productive heap dumps with hundreds of millions of
      objects, quickly calculate the retained sizes of objects, see
      who is preventing the Garbage Collector from collecting objects,
      run a report to automatically extract leak suspects.
    '';
    homepage = "https://www.eclipse.org/mat";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.epl20;
    maintainers = [ maintainers.ktor ];
    platforms = [ "x86_64-linux" ];
  };

}
