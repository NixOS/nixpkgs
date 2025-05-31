{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  autoPatchelfHook,
  autoreconfHook,
  cairo,
  ffmpeg-headless,
  freerdp,
  libjpeg_turbo,
  libpng,
  libossp_uuid,
  libpulseaudio,
  libssh2,
  libtelnet,
  libvncserver,
  libvorbis,
  libwebp,
  libwebsockets,
  makeBinaryWrapper,
  openssl,
  pango,
  perl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guacamole-server";
  version = "1.6.0-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "guacamole-server";
    rev = "acb69735359d4d4a08f65d6eb0bde2a0da08f751";
    hash = "sha256-rqGSQD9EYlK1E6y/3EzynRmBWJOZBrC324zVvt7c2vM=";
  };

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format-truncation"
    "-Wno-error=format-overflow"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    autoreconfHook
    makeBinaryWrapper
    perl
    pkg-config
  ];

  buildInputs = [
    cairo
    ffmpeg-headless
    freerdp
    libjpeg_turbo
    libossp_uuid
    libpng
    libpulseaudio
    libssh2
    libtelnet
    libvncserver
    libvorbis
    libwebp
    libwebsockets
    openssl
    pango
  ];

  configureFlags = [
    "--with-freerdp-plugin-dir=${placeholder "out"}/lib"
  ];

  postPatch = ''
    patchShebangs ./src/protocols/rdp/**/*.pl
  '';

  postInstall = ''
    ln -s ${freerdp}/lib/* $out/lib/
    wrapProgram $out/sbin/guacd --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  passthru.tests = {
    inherit (nixosTests) guacamole-server;
  };

  meta = {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.apache.org/";
    license = lib.licenses.asl20;
    mainProgram = "guacd";
    maintainers = [ lib.maintainers.drupol ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
