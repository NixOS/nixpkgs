{
  lib,
  stdenv,
  fetchFromGitHub,
  freetype,
}:

stdenv.mkDerivation rec {
  pname = "otf2bdf";
  version = "3.1_p1";

  # Original site http://sofia.nmsu.edu/~mleisher/Software/otf2bdf/ unreachable,
  # This is a mirror.
  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "otf2bdf";
    rev = "v${version}";
    hash = "sha256-8z1uqUhUPK+fMW3PLkvF3eSlSJpo0x+6NQ6vYsEMqoM=";
  };

  buildInputs = [ freetype ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    install otf2bdf $out/bin
    cp otf2bdf.man $out/share/man/man1/otf2bdf.1
  '';

  meta = with lib; {
    #homepage = "http://sofia.nmsu.edu/~mleisher/Software/otf2bdf/";  # timeout
    homepage = "https://github.com/jirutka/otf2bdf";
    description = "OpenType to BDF font converter";
    license = licenses.mit0;
    platforms = platforms.all;
    maintainers = with maintainers; [ hzeller ];
    mainProgram = "otf2bdf";
  };
}
