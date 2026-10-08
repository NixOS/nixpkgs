{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  alsa-lib,
  fontconfig,
  mesa_glu,
  libxcursor,
  libxinerama,
  libxrandr,
  xinput,
  libxi,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bonzomatic";
  version = "2023-06-15";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = "bonzomatic";
    tag = finalAttrs.version;
    hash = "sha256-hwK3C+p1hRwnuY2/vBrA0QsJGIcJatqq+U5/hzVCXEg=";
  };

  postPatch = ''
    substituteInPlace {,external/glfw/}CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    mesa_glu
    libxcursor
    libxinerama
    libxrandr
    xinput
    libxi
    libxext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic \
      --prefix LD_LIBRARY_PATH : "${lib.getLib alsa-lib}/lib"
  '';

  meta = {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.ilian ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "bonzomatic";
  };
})
