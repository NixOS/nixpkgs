{ lib, stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkg-config, libopus
, qrencode, gdk-pixbuf, libnotify }:

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "sha256-BabRY9iu5ccEXo5POrWkWaIWAeQU4MVlMK8I+Iju6aQ=";
  };

  makeFlags = [ "PREFIX=$(out)"];
  installFlags = [ "PREFIX=$(out)"];

  buildInputs = [
    libtoxcore libsodium ncurses curl gdk-pixbuf libnotify
  ] ++ lib.optionals (!stdenv.isAarch32) [
    openal libopus libvpx freealut qrencode
  ];
  nativeBuildInputs = [ pkg-config libconfig ];

  meta = with lib; src.meta // {
    description = "Reference CLI for Tox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
