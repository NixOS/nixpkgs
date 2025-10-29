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
  openssl,
  rigsofrods-bin,
  wayland,
  version ? "9.0.0-beta",
}:

let
unwrapped =
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

  # TODO: replace vendored libraries
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
    #openssl.out
    #openssl
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
    qttools
    #qt5compat
    #qtmultimedia
    #qtnetworkauth
    #qtpositioning
    #qtspeech
    #qtwebchannel
    #qtwebengine
  ]);

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src $out
    chmod 755 "$out"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    #rm -r $out/opt/pt/bin/libQt6*
    # creates errors:
    #/nix/store/sv8a90gmyh7mgymdhb3i3g4z25q8dkpv-ciscoPacketTracer9-9.0.0-beta/opt/pt/bin/PacketTracer: /nix/store/sv8a90gmyh7mgymdhb3i3g4z25q8dkpv-ciscoPacketTracer9-9.0.0-beta/opt/pt/bin/libssl.so.3: version `OPENSSL_3.2.0' not found (required by /nix/store/8np9zvwqmwsnbkbrwm8x7jq4ygdkjz5g-curl-8.16.0/lib/libcurl.so.4)
    #/nix/store/sv8a90gmyh7mgymdhb3i3g4z25q8dkpv-ciscoPacketTracer9-9.0.0-beta/opt/pt/bin/PacketTracer: /nix/store/sv8a90gmyh7mgymdhb3i3g4z25q8dkpv-ciscoPacketTracer9-9.0.0-beta/opt/pt/bin/libssl.so.3: version `OPENSSL_3.5.0' not found (required by /nix/store/lnykqqapknvsnm36ysviyd5hp1fy4add-ngtcp2-1.15.1/lib/libngtcp2_crypto_ossl.so.0)

    #rm -r $out/opt/pt/bin/libssl*
    # creates error:
    # tTracer: undefined symbol: _ZN16QWebSocketServer19handleTCPConnectionEP10QTcpSocketRK7QString, version Qt_6

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
};

  fhs-env = buildFHSEnv {
    name = "ciscoPacketTracer9-fhs-env";
    runScript = lib.getExe' unwrapped "packettracer9";
    targetPkgs = _: [ libudev0-shim ];
  };
in
fhs-env
