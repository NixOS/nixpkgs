{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, curl, libnotify, gdk-pixbuf }:

stdenv.mkDerivation {
  version = "2021-05-19";
  pname = "cmusfm-unstable";
  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "cmusfm";
    rev = "a1f9f37c5819ca8a5b48e6185c2ec7ad478b9f1a";
    sha256 = "19akgvh9gl99xvpmzgqv88w2mnnln7k6290dr5rn3h6a1ihvllaw";
  };
  # building
  configureFlags = [ "--enable-libnotify" ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];
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
    maintainers = with lib.maintainers; [ CharlesHD mudri ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
