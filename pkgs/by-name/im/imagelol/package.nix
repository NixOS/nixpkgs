{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libpng,
  stb,
}:

stdenv.mkDerivation rec {
  pname = "imagelol";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "MCRedstoner2004";
    repo = "imagelol";
    tag = "v${version}";
    sha256 = "0978zdrfj41jsqm78afyyd1l64iki9nwjvhd8ynii1b553nn4dmd";
    fetchSubmodules = true;
  };

  patches = [
    # upstream gcc-12 compatibility fix
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://github.com/MCredstoner2004/ImageLOL/commit/013fb1f901d88f5fd21a896bfab47c7fff0737d7.patch";
      hash = "sha256-RVaG2xbUqE4CxqI2lhvug2qihT6A8vN+pIfK58CXLDw=";
      includes = [ "imagelol/ImageLOL.inl" ];
      stripLen = 2;
      extraPrefix = "imagelol/";
    })
    # use system libraries instead of bundled versions
    ./use-system-libs.patch
  ];

  # fix for case-sensitive filesystems
  # https://github.com/MCredstoner2004/ImageLOL/issues/1
  postPatch = ''
    mv imagelol src
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory("imagelol")' 'add_subdirectory("src")'

    # use system stb headers
    substituteInPlace External/stb_image-cmake/CMakeLists.txt \
      --replace-fail '"''${CMAKE_CURRENT_SOURCE_DIR}/../stb"' '"${stb}/include/stb"'

    # remove bundled libraries
    rm -r External/zlib External/zlib-no-examples External/libpng External/stb
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libpng
    stb
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ImageLOL -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MCredstoner2004/ImageLOL";
    description = "Simple program to store a file into a PNG image";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "ImageLOL";
  };
}
