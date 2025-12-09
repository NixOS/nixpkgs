{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  lib,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "asmjit";
  version = "1.18-unstable-2025-11-03";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "b56f4176cb9b0c0501da659ac54d4c5877862c7b";
    hash = "sha256-fOYJak+DiGM3vazKwOffTGuqPuUi7p+I0phBmtfqzME=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

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
