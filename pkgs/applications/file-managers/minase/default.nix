{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libuchardet
, libiconv
, taglib
, zlib
# Whether to use nano's syntax highlighting files
, withNano ? true, nano
}:

stdenv.mkDerivation {
  pname = "minase";
  version = "unstable-2023-01-15";

  src = fetchFromGitHub {
    owner = "SAT1226";
    repo = "Minase";
    rev = "b9135d4d0f51fe27534f9ae0713d0fe952f5dd06"; # master
    hash = "sha256-Ex44qVJOiLnz+kAqELCjKTTPagG0EpAPkCdv/OI05SM=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace CMakeLists.txt --replace " -mfpmath=both" ""
  '' + lib.optionalString withNano ''
    substituteInPlace main.cpp --replace "/usr/share/nano" "${nano}/share/nano"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libuchardet
    libiconv
    taglib
    zlib
  ];

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/SAT1226/Minase";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
