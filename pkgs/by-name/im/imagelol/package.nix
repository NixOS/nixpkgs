{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
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
      # change lib/ for imagelol
      stripLen = 2;
      extraPrefix = "imagelol/";
    })
  ];

  # fix for case-sensitive filesystems
  # https://github.com/MCredstoner2004/ImageLOL/issues/1
  postPatch = ''
    mv imagelol src
    substituteInPlace CMakeLists.txt \
      --replace 'add_subdirectory("imagelol")' 'add_subdirectory("src")'

    substituteInPlace External/zlib-no-examples/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.4.4)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace External/libpng/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_policy(VERSION 3.1)" "cmake_policy(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./ImageLOL $out/bin
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-std=gnu90")
  ]
  ++ lib.optional (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
  ) "-DPNG_ARM_NEON=off";

  meta = with lib; {
    homepage = "https://github.com/MCredstoner2004/ImageLOL";
    description = "Simple program to store a file into a PNG image";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "ImageLOL";
  };
}
