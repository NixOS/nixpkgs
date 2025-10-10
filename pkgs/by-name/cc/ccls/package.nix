{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  rapidjson,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "ccls";
  version = "0.20241108-unstable-2025-08-15";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = "5660367c771345b68c4ead4a4db2d4786985bf78";
    sha256 = "sha256-R+5pL0orUdHtquqvJa4esNmc6ETbX8WK5oJlBCSG+uI=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];
  buildInputs = with llvmPackages; [
    libclang
    llvm
    rapidjson
  ];

  cmakeFlags = [ "-DCCLS_VERSION=${version}" ];

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-fvisibility=hidden -fno-rtti")
  '';

  clang = llvmPackages.clang;
  shell = runtimeShell;

  postFixup = ''
    export wrapped=".ccls-wrapped"
    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = with lib; {
    description = "C/c++ language server powered by clang";
    mainProgram = "ccls";
    homepage = "https://github.com/MaskRay/ccls";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      mic92
      tobim
    ];
  };
}
