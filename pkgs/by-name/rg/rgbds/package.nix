{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  pkg-config,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "rgbds";
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "gbdev";
    repo = "rgbds";
    rev = "v${version}";
    hash = "sha256-Rv2ylZavLy+G4XFLBdNGjk78hSb8cDoX9lW1l2TRmtk=";
  };
  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ];
  buildInputs = [ libpng ];
  postPatch = ''
    patchShebangs --host src/bison.sh
  '';
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://rgbds.gbdev.io/";
    description = "Free assembler/linker package for the Game Boy and Game Boy Color";
    license = licenses.mit;
    longDescription = ''
      RGBDS (Rednex Game Boy Development System) is a free assembler/linker package for the Game Boy and Game Boy Color. It consists of:

        - rgbasm (assembler)
        - rgblink (linker)
        - rgbfix (checksum/header fixer)
        - rgbgfx (PNG‐to‐Game Boy graphics converter)

      This is a fork of the original RGBDS which aims to make the programs more like other UNIX tools.
    '';
    maintainers = with maintainers; [
      matthewbauer
      NieDzejkob
    ];
    platforms = platforms.all;
  };
}
