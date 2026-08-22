{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "lzhl";
  version = "1.0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "TheSuperHackers";
    repo = "lzhl-1.0";
    rev = "dfd96e2ca64adaddb35dd4ebadd6add7d5586783";
    hash = "sha256-xGWZ/z19x0hFdE5A34s0TMQlZX0lPwaLflOIQOTB2Yg=";
  };

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    cp ${./CMakeLists.txt} CMakeLists.txt
  '';

  postInstall = ''
    mkdir -p $out/lib/cmake/lzhl
    cp ${./lzhl-config.cmake.in} $out/lib/cmake/lzhl/lzhl-config.cmake
    substituteInPlace $out/lib/cmake/lzhl/lzhl-config.cmake \
      --replace-fail '@out@' "$out"
  '';

  meta = {
    description = "LZH-style decompression library";
    longDescription = ''
      Port of the LZH decompression algorithm used by Command & Conquer:
      Generals for reading compressed game assets. Extracted from the
      original Generals decompression code and packaged as a standalone
      library for cross-platform use.
    '';
    homepage = "https://github.com/TheSuperHackers/lzhl-1.0";
    changelog = "https://github.com/TheSuperHackers/lzhl-1.0/commits/main";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
}
