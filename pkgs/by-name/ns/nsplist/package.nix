{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  flex,
}:

stdenv.mkDerivation {
  pname = "nsplist";
  version = "0-unstable-2017-04-11";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "NSPlist";
    rev = "713decf06c1ef6c39a707bc99eb45ac9925f2b8a";
    hash = "sha256-mRyuElLTlOZuUlQ3dKZJbclPq73Gv+YFrBCB5nh0nmw=";
  };

  nativeBuildInputs = [
    cmake
    flex
  ];

  preConfigure = ''
    # Regenerate the lexer for improved compatibility with clang 16.
    flex -o src/NSPlistLexer.cpp <(tail --lines=+17 src/NSPlistLexer.l)
  '';

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    description = "Parses .plist files";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
