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
  version = "0.18";

  src = fetchurl {
    url = "https://fnc.bsdbox.org/tarball/${finalAttrs.version}/fnc-${finalAttrs.version}.tar.gz";
    hash = "sha256-npS+sOxF0S/9TuFjtEFlev0HpIOsaP6zmcfopPNUehk=";
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
  );

  preInstall = ''
    mkdir -p $out/bin
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Interactive ncurses browser for Fossil repositories";
    longDescription = ''
      An interactive ncurses browser for Fossil repositories.

      fnc uses libfossil to create a fossil ui experience in the terminal.
    '';
    homepage = "https://fnc.bsdbox.org";
<<<<<<< HEAD
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ abbe ];
=======
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "fnc";
  };
})
