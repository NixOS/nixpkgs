{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "1.6.0-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "guacamole-server";
    rev = "d3b7828977c63a5b197158d6cbbdaf1846b579fb";
    hash = "sha256-sxZLzF6m35EtfLRHb1+aqR3RF+piOuvPT9w9Hs3cor0=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=format-truncation"
    "-Wno-error=format-overflow"
    "-Wno-error=deprecated-declarations"
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
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
