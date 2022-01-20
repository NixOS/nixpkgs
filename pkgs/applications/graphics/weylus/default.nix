{ lib
, dbus
, stdenv
, gst_all_1
, xorg
, libdrm
, libva
, fetchzip
, copyDesktopItems
, fontconfig
, libpng
, pipewire
, makeWrapper
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "weylus";
  version = "0.11.4";

  src = fetchzip {
    url = "https://github.com/H-M-H/Weylus/releases/download/v${version}/linux.zip";
    sha256 = "sha256-EW3TdI4F4d4X/BeSqI05QtS77ym1U5jdswFfNtSFyFk=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 ./weylus $out/bin/weylus
    copyDesktopItems ./weylus.desktop

    runHook postInstall
  '';

  buildInputs = [
    libpng
    dbus
    libdrm
    fontconfig
    libva
    gst_all_1.gst-plugins-base
    pipewire
    # autoPatchelfHook complains if these are missing, even on wayland
    xorg.libXft
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXtst
  ];

  nativeBuildInputs = [ copyDesktopItems autoPatchelfHook makeWrapper ];

  postFixup = let
    GST_PLUGIN_PATH = lib.makeSearchPathOutput  "lib" "lib/gstreamer-1.0" [
      gst_all_1.gst-plugins-base
      pipewire
    ];
  in ''
    wrapProgram $out/bin/weylus --prefix GST_PLUGIN_PATH : ${GST_PLUGIN_PATH}
  '';

  meta = with lib; {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    homepage = "https://github.com/H-M-H/Weylus";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ lom ];
    platforms = [ "x86_64-linux" ];
  };
}
