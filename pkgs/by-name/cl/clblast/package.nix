{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  ninja,
  opencl-headers,
  ocl-icd,
}:

stdenv.mkDerivation rec {
  pname = "clblast";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "CNugteren";
    repo = "CLBlast";
    rev = version;
    hash = "sha256-fzenYFCAQ0B2NQgh5OaErv/yNEzjznB6ogRapqfL6P4=";
  };

  patches = [
    (fetchpatch {
      name = "clblast-fix-cmake4.patch";
      url = "https://github.com/CNugteren/CLBlast/commit/dd714f1b72aa8c341e5a27aa9e968b4ecdaf1abb.patch";
      includes = [ "CMakeLists.txt" ];
      hash = "sha256-AVFzEdj1CaVSJxOcn5PoqFb+b8k5YgSMD3VhvHeBd7o=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    opencl-headers
    ocl-icd
  ];

  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "Tuned OpenCL BLAS library";
    homepage = "https://github.com/CNugteren/CLBlast";
    license = licenses.asl20;
    maintainers = with maintainers; [ Tungsten842 ];
    platforms = platforms.linux;
  };
}
