{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  python3,
  vulkan-headers,
  xorg
}:
stdenv.mkDerivation rec {
  pname = "slang";
  version = "2024.14.6";
  rev = "e6cf93e3e638cb981a9be392a2f48ea06acd4e3f";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "shader-slang";
    repo = "slang";
    inherit rev;
    fetchSubmodules = true;
    hash = "sha256-q/FR7CA3FddbHBmINOqQqfmOhlusswv3femKFax2AnM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    vulkan-headers
    xorg.libX11
  ];

  cmakeFlags = [
    "-DSLANG_VERSION_FULL=${rev}"
  ];

  configurePhase = ''
    cmake --preset default
  '';

  buildPhase = ''
    cmake --build --preset release
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $dev/dev
    mkdir -p $doc/doc

    cmake --install ./build --prefix $out

    mv $out/include $dev/include
    mv $out/share $doc/share
  '';

  meta = {
    description = "Shader language compiler and LSP maintained by khronos";
    homepage = "https://shader-slang.com/";
    license = lib.licenses.asl20-llvm;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "slangc";
  };
}
