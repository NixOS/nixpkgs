{ mkDerivation, stdenv, lib, fetchurl, rpmextract, autoPatchelfHook , libuuid
, libXtst, libXfixes, glib, gst_all_1, alsa-lib, freetype, fontconfig , libXext
, libGL, libpng, libXScrnSaver, libxcb, xorg, libpulseaudio, libdrm
}:
mkDerivation rec {
  pname = "hpmyroom";
  version = "12.13.0.0749";

  src = fetchurl {
    url = "https://www.myroom.hpe.com/downloadfiles/${pname}-${version}.x86_64.rpm";
    sha256 = "sha256-Ff3j14rC2ZHhNJLPxvKn9Sxyv351HuHbggclwOuFfX4=";
  };

  nativeBuildInputs = [
    rpmextract autoPatchelfHook
  ];

  buildInputs = [
    libuuid libXtst libXScrnSaver libXfixes alsa-lib freetype fontconfig libXext
    libGL libpng libxcb libpulseaudio libdrm
    glib  # For libgobject
    stdenv.cc.cc  # For libstdc++
    xorg.libX11
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base ]);

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out

    runHook postInstall
  '';

  qtWrapperArgs = [
    "--prefix QT_XKB_CONFIG_ROOT : '${xorg.xkeyboardconfig}/share/X11/xkb'"
  ];

  postFixup = ''
    substituteInPlace $out/share/applications/HP-myroom.desktop \
      --replace /usr/bin/hpmyroom hpmyroom \
      --replace Icon=/usr/share/hpmyroom/Resources/MyRoom.png Icon=$out/share/hpmyroom/Resources/MyRoom.png

    ln -s ${libpng}/lib/libpng.so $out/lib/hpmyroom/libpng15.so.15
  '';

  meta = {
    description = "Client for HPE's MyRoom web conferencing solution";
    maintainers = with lib.maintainers; [ johnazoidberg ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    homepage = "https://myroom.hpe.com";
    # TODO: A Darwin binary is available upstream
    platforms = [ "x86_64-linux" ];
    mainProgram = "hpmyroom";
    broken = true; # requires libpng15
  };
}
