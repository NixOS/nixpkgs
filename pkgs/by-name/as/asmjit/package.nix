{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  lib,
}:

stdenv.mkDerivation {
  pname = "asmjit";
  version = "0-unstable-2025-02-12";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "029075b84bf0161a761beb63e6eda519a29020db";
    hash = "sha256-/9F1rFNPwJUrVOVeK9sIA+Q7UrqQpQy8T6g4ywcoJc8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Machine code generation for C++";
    longDescription = ''
      AsmJit is a lightweight library for machine code generation written in
      C++ language. It can generate machine code for X86, X86_64, and AArch64
      architectures and supports baseline instructions and all recent
      extensions.
    '';
    homepage = "https://asmjit.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ thillux ];
  };
}
