{
  config,
  lib,
  stdenv,
  autoPatchelfHook,
  autoreconfHook,
  fetchFromGitHub,
  nix-update-script,

  chromecastSupport ? config.chromecast or stdenv.hostPlatform.isLinux,
  pulseSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,

  avahi,
  curl,
  bison,
  ffmpeg,
  flex,
  gettext,
  gnutls,
  gperf,
  json_c,
  libconfuse,
  libevent,
  libgcrypt,
  libgpg-error,
  libplist,
  libpulseaudio,
  libsodium,
  libtool,
  libunistring,
  libwebsockets,
  libxml2,
  pkg-config,
  protobufc,
  sqlite,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "28.12";
  pname = "owntone";

  src = fetchFromGitHub {
    owner = "owntone";
    repo = "owntone-server";
    tag = finalAttrs.version;
    hash = "sha256-Mj3G1+Hwa/zl0AM4SO6TcB4W3WJkpIDzrSPEFx0vaEk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    autoreconfHook
    bison
    flex
    libtool
    gperf
    pkg-config
  ];

  buildInputs = [
    avahi
    curl
    ffmpeg
    gettext
    json_c
    libconfuse
    libevent
    libgcrypt
    libgpg-error
    libplist
    libsodium
    libunistring
    libwebsockets
    libxml2
    protobufc
    sqlite
    zlib
  ]
  ++ lib.optionals chromecastSupport [ gnutls ]
  ++ lib.optionals pulseSupport [ libpulseaudio ];

  configureFlags =
    lib.optionals chromecastSupport [ "--enable-chromecast" ]
    ++ lib.optionals pulseSupport [ "--with-pulseaudio" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Media server to stream audio to AirPlay and Chromecast receivers";
    homepage = "https://github.com/owntone/owntone-server";
    downloadPage = "https://github.com/owntone/owntone-server/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/owntone/owntone-server/releases/tag/${finalAttrs.version}";
    mainProgram = "owntone";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      hensoko
    ];
    platforms = lib.platforms.linux;
  };
})
