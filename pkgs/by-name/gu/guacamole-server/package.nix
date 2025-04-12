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
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "guacamole-server";
    rev = finalAttrs.version;
    hash = "sha256-ZrUaoWkZ3I/LxE7csDXXeUZ92jZDhkZ1c8EQU0gI1yY=";
  };

  patches = [
    # GUACAMOLE-1952: Add compatibility with FFMPEG 7.0
    (fetchpatch2 {
      url = "https://github.com/apache/guacamole-server/commit/cc8addf9beb90305037a32f9f861a893be4cae08.patch?full_index=1";
      hash = "sha256-VCr2/8lQHKVdsdah9gvak4MjFHO+X4ixE5+zsvwIY1I=";
    })
  ];

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
