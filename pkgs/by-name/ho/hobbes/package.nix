{
  lib,
  stdenv,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  llvm_12,
  ncurses,
  readline,
  zlib,
  libxml2,
  python3,
}:
llvmPackages.stdenv.mkDerivation {
  pname = "hobbes";
  version = "0-unstable-2025-04-23";

  src = fetchFromGitHub {
    owner = "morganstanley";
    repo = "hobbes";
    rev = "0829030be03d47f91075cbebd0c9565f44bf9911";
    hash = "sha256-GZ26XL4++2MWQED2tVWeJ8HFcFQUXnXZ3+JCgdlAXNo=";
  };

  CXXFLAGS = [
    "-Wno-error=missing-template-arg-list-after-template-kw"
    "-Wno-error=deprecated-copy"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvm_12
    ncurses
    readline
    zlib
    libxml2
    python3
  ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Language and an embedded JIT compiler";
    longDescription = ''
      Hobbes is a a language, embedded compiler, and runtime for efficient
      dynamic expression evaluation, data storage and analysis.
    '';
    homepage = "https://github.com/morganstanley/hobbes";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kthielen
      thmzlt
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
