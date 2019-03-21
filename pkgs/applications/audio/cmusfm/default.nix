{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, curl, libnotify, gdk_pixbuf }:

stdenv.mkDerivation rec {
  version = "2018-10-11";
  name = "cmusfm-unstable-${version}";
  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "cmusfm";
    rev = "ad2fd0aad3f4f1a25add1b8c2f179e8859885873";
    sha256 = "0wpwdwgyrp64nvwc6shy0n387p31j6aw6cnmfi9x2y1jhl5hbv6b";
  };
  # building
  configureFlags = [ "--enable-libnotify" ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ curl libnotify gdk_pixbuf ];

  meta = with stdenv.lib; {
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
    homepage = https://github.com/Arkq/cmusfm/;
    maintainers = with stdenv.lib.maintainers; [ CharlesHD ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
