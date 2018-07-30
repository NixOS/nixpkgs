{ stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig, libopus
, libqrencode, gdk_pixbuf, libnotify }:

stdenv.mkDerivation rec {
  name = "toxic-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "0fwmk945nip98m3md58y3ibjmzfq25hns3xf0bmbc6fjpww8d5p5";
  };

  makeFlags = [ "PREFIX=$(out)"];
  installFlags = [ "PREFIX=$(out)"];

  buildInputs = [
    libtoxcore libsodium ncurses curl gdk_pixbuf libnotify
  ] ++ stdenv.lib.optionals (!stdenv.isAarch32) [
    openal libopus libvpx freealut libqrencode
  ];
  nativeBuildInputs = [ pkgconfig libconfig ];

  meta = with stdenv.lib; {
    description = "Reference CLI for Tox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jgeerds ];
    platforms = platforms.linux;
  };
}
