{ lib, stdenv, fetchFromGitHub, fetchpatch, libsodium, ncurses, curl
, libtoxcore, openal, libvpx, freealut, libconfig, pkg-config, libopus
, qrencode, gdk-pixbuf, libnotify }:

stdenv.mkDerivation rec {
  pname = "toxic";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner  = "Tox";
    repo   = "toxic";
    rev    = "v${version}";
    sha256 = "sha256-5jLXXI+IMrYa7ZtdMjJrah1zB5TJ3GdHfvcMd1TYE4E=";
  };

  patches = [
    # Pending for upstream inclusion fix for ncurses-6.3 compatibility.
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/JFreegman/toxic/commit/41e93adbdbd56db065166af5a6676a7996e9e451.patch";
      sha256 = "sha256-LYEseB5FmXFNifa1RZUxhkXeWlkEEMm3ASD55IoUPa0=";
    })
  ];

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
