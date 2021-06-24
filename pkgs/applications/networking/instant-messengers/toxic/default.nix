{ lib, stdenv, fetchFromGitHub, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkg-config, libopus
, qrencode, gdk-pixbuf, libnotify }:

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "sha256-EElDi/VEYgYPpoDNatxcKQC1pnCU8kOcj0bAFojD9fU=";
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
