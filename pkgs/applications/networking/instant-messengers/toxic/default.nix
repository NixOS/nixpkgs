{ lib, stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkg-config, libopus
, qrencode, gdk-pixbuf, libnotify }:

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "1v9cdpy6i3xl70g75zg33sqi4aqp20by0pyjhjg5iz24fxvfaw6c";
  };

  makeFlags = [ "PREFIX=$(out)"];
  installFlags = [ "PREFIX=$(out)"];

  buildInputs = [
    libtoxcore libsodium ncurses curl gdk-pixbuf libnotify
  ] ++ lib.optionals (!stdenv.isAarch32) [
    openal libopus libvpx freealut qrencode
  ];
  nativeBuildInputs = [ pkg-config libconfig ];

  meta = with lib; {
    description = "Reference CLI for Tox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
