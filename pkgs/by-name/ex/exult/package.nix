{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  autoconf,
  autoconf-archive,
  autoreconfHook,
  automake,
  libogg,
  libtool,
  libvorbis,
  libX11,
  pkg-config,
  zlib,
  enableTools ? false,
}:

stdenv.mkDerivation rec {
  pname = "exult";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "exult";
    repo = "exult";
    rev = "v${version}";
    hash = "sha256-SZwYaqTTWESNRphXefa3JyH988y3WiaIr12yORhiFow=";
  };

  # We can't use just DESTDIR because with it we'll have /nix/store/...-exult-1.12.0/nix/store/...-exult-1.12.0/bin
  postPatch = ''
    substituteInPlace macosx/macosx.am \
      --replace-fail DESTDIR NIX_DESTDIR
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    autoreconfHook
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    SDL2
    libogg
    libvorbis
    libX11
    zlib
  ];

  enableParallelBuilding = true;

  makeFlags = [ "NIX_DESTDIR=$(out)" ]; # see postPatch
  configureFlags = lib.optional (!enableTools) "--disable-tools";

  meta = with lib; {
    description = "Recreation of Ultima VII for modern operating systems";
    longDescription = ''
      Ultima VII, an RPG from the early 1990's, still has a huge following. But,
      being a DOS game with a very nonstandard memory manager, it is difficult
      to run it on the latest computers. Exult is a project that created an
      Ultima VII game engine that runs on modern operating systems, capable of
      using the data and graphics files that come with the game. Exult aims to
      let those people who own Ultima VII play the game on modern hardware, in
      as close to (or perhaps even surpassing) its original splendor as is
      possible.
    '';
    homepage = "http://exult.info";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "exult";
  };
}
