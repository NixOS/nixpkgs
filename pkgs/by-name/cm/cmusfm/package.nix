{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  libnotify,
  gdk-pixbuf,
  libnotifySupport ? stdenv.hostPlatform.isLinux,
  debug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmusfm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "cmusfm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CA585ZpkxMMLgzv81QB2kKMFg5R5CwKS9xAYrU+pAxs=";
  };

  configureFlags =
    lib.optional libnotifySupport "--enable-libnotify" ++ lib.optional debug "--enable-debug";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    gdk-pixbuf
  ]
  ++ lib.optional libnotifySupport libnotify;

  meta = {
    description = "Last.fm and Libre.fm standalone scrobbler for the cmus music player";
    longDescription = ''
      Features:
      + Listening now notification support
      + Off-line played track cache for later submission
      + POSIX ERE-based file name parser
      + Desktop notification support (optionally)
      + Customizable scrobbling service
      + Small memory footprint
      Configuration:
      + run `cmusfm init` to generate configuration file under ~/.config/cmus/cmusfm.conf
      + Inside cmus run `:set status_display_program=cmusfm` to set up cmusfm
    '';
    homepage = "https://github.com/Arkq/cmusfm/";
    maintainers = with lib.maintainers; [
      CharlesHD
      mudri
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cmusfm";
  };
})
