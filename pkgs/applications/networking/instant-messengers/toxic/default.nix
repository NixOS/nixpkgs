{ stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig, libopus
, qrencode, gdk_pixbuf, libnotify }:

stdenv.mkDerivation rec {
  name = "toxic-${version}";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "09l2j3lwvrq7bf3051vjsnml9w63790ly3iylgf26gkrmld6k31w";
  };

  makeFlags = [ "PREFIX=$(out)"];
  installFlags = [ "PREFIX=$(out)"];

  buildInputs = [
    libtoxcore libsodium ncurses curl gdk_pixbuf libnotify
  ] ++ stdenv.lib.optionals (!stdenv.isAarch32) [
    openal libopus libvpx freealut qrencode
  ];
  nativeBuildInputs = [ pkgconfig libconfig ];

  meta = with stdenv.lib; {
    description = "Reference CLI for Tox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jgeerds ];
    platforms = platforms.linux;
  };
}
