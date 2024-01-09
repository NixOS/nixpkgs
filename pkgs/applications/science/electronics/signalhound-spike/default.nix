{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, unzip
, autoPatchelfHook
, fontconfig
, freetype
, udev
, libICE
, libSM
, libX11
, libXcursor
, libXext
, libXi
, libXfixes
, libXrandr
, libXrender
, libxcb
, xcbutilrenderutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilwm
, libxkbcommon
, libGL
, libusb
, libpulseaudio
, libpng
, harfbuzz
, zlib
, icu60
, double-conversion
, glib
, makeWrapper
}:

let
double-conversion1 = double-conversion.overrideAttrs (old: rec {
  version = "2.0.4";
  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "${version}";
    hash = "sha256-EHgFvHNF16GphJO1tWLir26cLe1srSo4vZULd1oHX/I=";
  };
});
in stdenv.mkDerivation rec {
  pname = "signalhound-spike";
  version = "3.9.0";

  src = fetchurl {
    url = "https://signalhound.com/sigdownloads/Spike/Spike(Ubuntu22.04x64)_${(lib.replaceStrings ["."] ["_"] version)}.zip";
    hash = "sha256-mEZbRU+81odHJ4X1a1t7LRSWcpfkPGCCBqiVI4ZtEXM=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];
  buildInputs = [ double-conversion1 ];

  rpath = lib.makeLibraryPath [
    fontconfig
    freetype
    libICE
    libSM
    udev
    libX11
    libXcursor
    libXext
    libXfixes
    libXrandr
    libXrender
    libXi
    libxcb
    xcbutilrenderutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm
    libxkbcommon
    libGL
    libusb
    libpulseaudio
    libpng
    harfbuzz
    zlib
    icu60
    double-conversion1
    glib
  ]
  + ":${stdenv.cc.cc.lib}/lib64";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/plugins
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
    mkdir -p $out/lib/udev/rules.d
    mv bin/* $out/bin/.
    mv lib/* $out/lib/.
    ln -s $out/lib/libbb_api.so.5.0.6 $out/lib/libbb_api.so.5
    ln -s $out/lib/libsm_api.so.2.3.3 $out/lib/libsm_api.so.2
    ln -s $out/lib/libsp_api.so.1.0.0 $out/lib/libsp_api.so.1
    ln -s $out/lib/libQt5PrintSupport.so.5.9.5 $out/lib/libQt5PrintSupport.so.5
    ln -s $out/lib/libQt5Core.so.5.9.5 $out/lib/libQt5Core.so.5
    ln -s $out/lib/libQt5DBus.so.5.9.5 $out/lib/libQt5DBus.so.5
    ln -s $out/lib/libQt5Gui.so.5.9.5 $out/lib/libQt5Gui.so.5
    ln -s $out/lib/libQt5Widgets.so.5.9.5 $out/lib/libQt5Widgets.so.5
    ln -s $out/lib/libQt5OpenGL.so.5.9.5 $out/lib/libQt5OpenGL.so.5
    ln -s $out/lib/libQt5Multimedia.so.5.9.5 $out/lib/libQt5Multimedia.so.5
    ln -s $out/lib/libQt5Network.so.5.9.5 $out/lib/libQt5Network.so.5
    ln -s $out/lib/libQt5XcbQpa.so.5.9.5 $out/lib/libQt5XcbQpa.so.5
    mv plugins/* $out/plugins/.
    mv manuals $out/.
    mv com.signalhound.spike.desktop $out/share/applications/.
    mv assets/com.signalhound.spike.png $out/share/icons/.
    mv sh.rules $out/lib/udev/rules.d/99-signalhound.rules
    chmod 755 $out/bin/Spike
    mv $out/bin/Spike $out/bin/Spike.bin
    makeWrapper $out/bin/Spike.bin $out/bin/Spike \
      --set QT_DEBUG_PLUGINS 1 \
      --set QT_PLUGIN_PATH $out/plugins
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/bin/Spike.bin" \
      --set-rpath ${rpath}:$out/lib "$out/bin/Spike.bin"

    for file in $(find $out/lib -maxdepth 1 -type f -and -name \*.so\*); do
      patchelf --set-rpath ${rpath}:$out/lib $file
    done

    for file in $(find $out/plugins -maxdepth 2 -type f -and -name \*.so\*); do
      patchelf --set-rpath ${rpath}:$out/lib $file
    done
  '';

  meta = with lib; {
    description = "SignalHounds Real-time Spectrum Analyzer and Visualization Tool";
    longDescription = ''
      Spike is a real-time spectrum analyzer and visualization tool for SignalHound USB Analyzers
      and signal generators.
    '';
    homepage = "https://signalhound.com/spike/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.teburd ];
    platforms = [ "x86_64-linux" ];
  };
}

