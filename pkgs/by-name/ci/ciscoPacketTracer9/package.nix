#nixpkgs ❯ result/bin/packettracer9
#Path override failed for key base::DIR_APP_DICTIONARIES and path '/nix/store/kf4h10c3r2sv20fjg5wx99x8b9163kl2-ciscoPacketTracer9-9.0.0-beta/opt/pt/bin/qtwebengine_dictionaries'
#Path override failed for key base::DIR_APP_DICTIONARIES and path '/nix/store/kf4h10c3r2sv20fjg5wx99x8b9163kl2-ciscoPacketTracer9-9.0.0-beta/opt/pt/bin/qtwebengine_dictionaries'
#zsh: trace trap  result/bin/packettracer9

{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  dpkg,
  kdePackages,
  xorg,
  makeWrapper,
  alsa-lib,
  expat,
  fontconfig,
  freetype,
  glib,
  libdrm,
  libglvnd,
  libpulseaudio,
  libudev0-shim,
  libxkbcommon,
  libxml2_13,
  libxslt,
  nss,
  rigsofrods-bin,
  wayland,
  version ? "9.0.0-beta",
}:

stdenv.mkDerivation {
  pname = "ciscoPacketTracer9";
  inherit version;

  src =
    let
      source =
        {
          "9.0.0-beta" = {
            name = "CiscoPacketTracer900_Open_Beta_July_Build680_linux_amd64_Exp20251231.deb";
            hash = "sha256-7PFhw16Y+GZJvb5gpq0jZRnCJagOrpHR8SRGjhTw/Xo=";
          };
        }
        .${version};
    in
    requireFile {
      inherit (source) name hash;
      url = "https://www.netacad.com/articles/news/download-cisco-packet-tracer";
    };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    kdePackages.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    expat
    fontconfig
    freetype
    glib
    libdrm
    libglvnd
    libpulseaudio
    libudev0-shim
    libxkbcommon
    libxml2_13
    libxslt
    nss
    wayland
  ]
  ++ (with xorg; [
    libICE
    libSM
    libX11
    libXcomposite
    libXdamage
    libXrandr
    libXtst
    libxcb
    libxkbfile
    xcbutilcursor
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
  ])
  ++ (with kdePackages; [
    # TODO: replace vendored qt6 libraries
    qttools
  ]);

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src $out
    chmod 755 "$out"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # TODO: package libtiff and use that
    cp ${rigsofrods-bin}/share/rigsofrods/lib/libtiff.so.5 $out/opt/pt/bin/

    makeWrapper "$out/opt/pt/bin/PacketTracer" "$out/bin/packettracer9" \
      --set QTWEBENGINE_LOCALES_PATH "$out/opt/pt/translations/qtwebengine_locales"

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libLLVM-11.so.1"
    "libclang-cpp.so.11"
  ];

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "packettracer9";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
