{ stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig, libopus
, qrencode, gdk-pixbuf, libnotify }:

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "0p1cmj1kyp506y5xm04mhlznhf5wcylvgsn6b307ms91vjqs3fg2";
  };

  makeFlags = [ "PREFIX=$(out)"];
  installFlags = [ "PREFIX=$(out)"];

  buildInputs = [
    libtoxcore libsodium ncurses curl gdk-pixbuf libnotify
  ] ++ stdenv.lib.optionals (!stdenv.isAarch32) [
    openal libopus libvpx freealut qrencode
  ];
  nativeBuildInputs = [ pkgconfig libconfig ];

  meta = with stdenv.lib; {
    description = "Reference CLI for Tox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
