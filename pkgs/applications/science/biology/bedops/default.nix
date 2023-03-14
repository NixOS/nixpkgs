{ lib, stdenv, fetchFromGitHub, zlib, bzip2, jansson, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "bedops";
  version = "2.4.41";

  src = fetchFromGitHub {
    owner = "bedops";
    repo = "bedops";
    rev = "v${version}";
    sha256 = "sha256-VJBoi1+tHA4oOVOsClUfimB+mOV5ZSQsDcDq3vAZwBA=";
  };

  buildInputs = [ zlib bzip2 jansson ];
  nativeBuildInputs = [ makeWrapper ];

  preConfigure = ''
    # We use nixpkgs versions of these libraries
    rm -r third-party
    sed -i '/^LIBS/d' system.mk/*
    sed -i 's|^LIBRARIES.*$|LIBRARIES = -lbz2 -lz -ljansson|' */*/*/*/Makefile
    substituteInPlace applications/bed/starch/src/Makefile --replace '$(LIBRARIES)' ""

    # Function name is different in nixpkgs provided libraries
    for f in interfaces/src/data/starch/starchFileHelpers.c applications/bed/starch/src/starchcat.c ; do
      substituteInPlace $f --replace deflateInit2cpp deflateInit2
    done

    # Don't force static
    for f in */*/*/*/Makefile ; do
      substituteInPlace $f --replace '-static' ""
    done
  '';

  makeFlags = [ "BINDIR=$(out)/bin" ];

  postFixup = ''
    for f in $out/bin/* ; do
      wrapProgram $f --prefix PATH : "$out/bin"
    done
  '';

  meta = with lib; {
    description = "Suite of tools for addressing questions arising in genomics studies";
    homepage = "https://github.com/bedops/bedops";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
    broken = stdenv.isDarwin;
  };
}
