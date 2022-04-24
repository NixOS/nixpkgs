{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, curl, libnotify
, gdk-pixbuf, libnotifySupport ? stdenv.isLinux, debug ? false }:

stdenv.mkDerivation rec {
  pname = "cmusfm";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Arkq";
    repo = pname;
    rev = "v${version}";
    sha256 = "1px2is80jdxchg8cpn5cizg6jvcbzyxl0qzs3bn0k3d10qjvdww5";
  };

  configureFlags = lib.optional libnotifySupport "--enable-libnotify"
    ++ lib.optional debug "--enable-debug";

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ curl gdk-pixbuf ]
    ++ lib.optional libnotifySupport libnotify;

  meta = with lib; {
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
    maintainers = with lib.maintainers; [ CharlesHD mudri ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
