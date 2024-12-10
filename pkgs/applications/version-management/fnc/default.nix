{
  lib,
  fetchurl,
  stdenv,
  zlib,
  ncurses,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fnc";
  version = "0.16";

  src = fetchurl {
    url = "https://fnc.bsdbox.org/tarball/${finalAttrs.version}/fnc-${finalAttrs.version}.tar.gz";
    hash = "sha256-6I6wtSMHaKdnlUK4pYiaybJeODGu2P+smYW8lQDIWGM=";
  };

  buildInputs = [
    libiconv
    ncurses
    zlib
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12
      "-Wno-error=maybe-uninitialized"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # error: 'strtonum' is only available on macOS 11.0 or newer
      "-Wno-error=unguarded-availability-new"
    ]
  );

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Interactive ncurses browser for Fossil repositories";
    longDescription = ''
      An interactive ncurses browser for Fossil repositories.

      fnc uses libfossil to create a fossil ui experience in the terminal.
    '';
    homepage = "https://fnc.bsdbox.org";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbe ];
    mainProgram = "fnc";
  };
})
