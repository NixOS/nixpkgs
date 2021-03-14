{ lib, stdenv, fetchFromGitHub, pkg-config, dbus-glib, autoreconfHook, xorg }:

stdenv.mkDerivation {
  pname = "kbdd";
  version = "unstable-2017-01-29";

  src = fetchFromGitHub {
    owner = "qnikst";
    repo = "kbdd";
    rev = "0e1056f066ab6e3c74fd0db0c9710a9a2b2538c3";
    sha256 = "068iqkqxh7928xlmz2pvnykszn9bcq2qgkkiwf37k1vm8fdmgzlj";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ xorg.libX11 dbus-glib ];

  meta = {
    description = "Simple daemon and library to make per window layout using XKB";
    homepage = "https://github.com/qnikst/kbdd";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.wedens ];
  };
}
