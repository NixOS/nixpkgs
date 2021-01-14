{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, curl, libnotify, gdk-pixbuf }:

stdenv.mkDerivation {
  version = "2020-07-23";
  pname = "cmusfm-unstable";
  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "cmusfm";
    rev = "73df3e64d8aa3b5053b639615b8f81d512420e52";
    sha256 = "1p9i65v8hda9bsps4hm9m2b7aw9ivk4ncllg8svyp455gn5v8xx6";
  };
  # building
  configureFlags = [ "--enable-libnotify" ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ curl libnotify gdk-pixbuf ];

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
    maintainers = with stdenv.lib.maintainers; [ CharlesHD ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
