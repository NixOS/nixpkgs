{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig }:

let
  version = "0.5.1";
in stdenv.mkDerivation rec {
  name = "toxic-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/archive/v${version}.tar.gz";
    sha256 = "0zzfgwm17a4xcy9l0ll2pksp45mz6f4s3isdrgjpw1xibv9xnzcm";
  };

  makeFlags = [ "-Cbuild" "VERSION=${version}" "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    autoconf libtool automake libtoxcore libsodium ncurses
    libconfig pkgconfig
  ] ++ stdenv.lib.optionals (!stdenv.isArm) [
    openal libvpx freealut
  ];

  meta = {
    description = "Reference CLI for Tox";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
