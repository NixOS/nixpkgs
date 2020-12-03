{ stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig, libopus
, qrencode, gdk-pixbuf, libnotify }:

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "1j0yd33sm824dy4mhwfxqkywa46yhqy5hd5wq4lp7lgl6m6mypar";
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
