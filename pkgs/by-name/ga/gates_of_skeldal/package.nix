{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gates-of-skeldal";
  version = "0-unstable-2025-03-05";

  src = fetchFromGitHub {
    owner = "ondra-novak";
    repo = "gates_of_skeldal";
    rev = "c7b575821c67c373e561909d93165cc55baf2f06";
    hash = "sha256-O6vgUyvXm6DupsUsxOlQbksR/GJkRQtUhUbWLn35QYA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    zlib
  ];

  cmakeFlags = [ ];

  preConfigure = ''
    echo "Removing -Werror from CMake configuration..."
    find . -type f -name 'CMakeLists.txt' -exec sed -i 's/-Werror//g' {} +
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/
  '';

  meta = {
    description = "Open source release of the game 'Brány Skeldalu' (Gates of Skeldal)";
    homepage = "https://github.com/ondra-novak/gates_of_skeldal";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
