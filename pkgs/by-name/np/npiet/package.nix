{
  lib,
  stdenv,
  fetchurl,
  gd,
  giflib,
  groff,
  libpng,
  tk,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "npiet";
  version = "1.3f";

  src = fetchurl {
    url = "https://www.bertnase.de/npiet/npiet-${finalAttrs.version}.tar.gz";
    hash = "sha256-Le2FYGKr1zWZ6F4edozmvGC6LbItx9aptidj3KBLhVo=";
  };

  buildInputs = [
    gd
    giflib
    libpng
  ];

  nativeBuildInputs = [ groff ];

  postPatch = ''
    # malloc.h is not needed because stdlib.h is already included.
    # On macOS, malloc.h does not even exist, resulting in an error.
    substituteInPlace npiet-foogol.c \
      --replace-fail '#include <malloc.h>' ""

    substituteInPlace npietedit \
      --replace-fail 'exec wish' 'exec ${tk}/bin/wish'
  '';

  strictDeps = true;

  passthru.tests =
    let
      all-tests = callPackage ./tests { };
    in
    {
      inherit (all-tests)
        hello
        prime
        no-prime
        brainfuck
        ;
    };

  meta = {
    description = "Interpreter for piet programs. Also includes npietedit and npiet-foogol";
    longDescription = ''
      npiet is an interpreter for the piet programming language.
      Instead of text, piet programs are pictures. Commands are determined based on changes in color.
    '';
    homepage = "https://www.bertnase.de/npiet/";
    changelog = "https://www.bertnase.de/npiet/ChangeLog";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "npiet";
    maintainers = with lib.maintainers; [ Luflosi ];
  };
})
