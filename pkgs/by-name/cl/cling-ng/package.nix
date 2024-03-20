{ lib
, stdenv
, cmake
, fetchFromGitHub
, ninja
, python3
, ncurses
, zlib
}:

let
  clingRepo = "cling";
  llvmRepo = "llvm-project";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cling-ng";
  version = "1.0-unstable-2024-01-25";

  srcs = let owner = "root-project"; in [
    (fetchFromGitHub {
      inherit owner;
      repo = clingRepo;

      rev = "e5b63c66a608cb5585a9f6a72e3a30bfb116a9bc";
      hash = "sha256-Z6IWP3BWagT3YGmleebFSPTgZNUIOvVSoMZMQtih0gA=";

      # for v1.0
      #rev = "refs/tags/v${finalAttrs.version}";
      #hash = "sha256-Ye8EINzt+dyNvUIRydACXzb/xEPLm0YSkz08Xxw3xp4=";

      name = clingRepo;
    })
    (fetchFromGitHub {
      inherit owner;
      repo = llvmRepo;

      rev = "refs/tags/cling-llvm16-20240119-01";
      hash = "sha256-4qpWBodfcLp3rAV4fgjj2dp49dGHMzkKsVgto3tNZgw=";

      # for v1.0
      #rev = "refs/tags/cling-llvm13-20231016-01";
      #hash = "sha256-Unw5RzYcVYJsViaM9t+QhuBXzTY/r6qo9TDzwZkFi5c=";

      name = llvmRepo;
    })
  ];

  sourceRoot = ".";

  # for when building under nix-shell
  postUnpack = ''
    chmod u+w -R .
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    ncurses
    zlib
  ];

  cmakeDir = "../${llvmRepo}/llvm";

  cmakeFlags = [
    "-DLLVM_BUILD_TOOLS=OFF"
    "-DLLVM_ENABLE_PROJECTS=clang"
    "-DLLVM_EXTERNAL_CLING_SOURCE_DIR=../${clingRepo}"
    "-DLLVM_EXTERNAL_PROJECTS=cling"
    "-DLLVM_TARGETS_TO_BUILD=host;NVPTX"
  ];

  meta = with lib; {
    description = "The Interactive C++ Interpreter";
    homepage = "https://root.cern/cling/";
    license = with licenses; [ lgpl21 ncsa ];
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.unix;
  };
})
