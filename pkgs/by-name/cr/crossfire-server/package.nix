{
  stdenv,
  lib,
  pkgs,
  fetchgit,
  autoconf,
  automake,
  libtool,
  flex,
  perl,
  check,
  pkg-config,
  python3,
  # Included here so that hosts using custom maps/archetypes can easily override.
  maps ? pkgs.crossfire-maps,
  arch ? pkgs.crossfire-arch,
}:

stdenv.mkDerivation {
  pname = "crossfire-server";
  version = "2025-04";

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-server";
    rev = "5f742b9f9f785e4a59a3a463bee1f31c9bc67098";
    hash = "sha256-e7e3xN7B1cv9+WkZGzOJgrFer50Cs0L/2dYB9RmGCiE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    flex
    perl
    check
    pkg-config
    python3
  ];
  hardeningDisable = [ "format" ];

  preConfigure = ''
    ln -s ${arch} lib/arch
    ln -s ${maps} lib/maps
    sh autogen.sh
  '';

  configureFlags = [ "--with-python=${python3}" ];

  postInstall = ''
    ln -s ${maps} "$out/share/crossfire/maps"
  '';

  meta = with lib; {
    description = "Server for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
