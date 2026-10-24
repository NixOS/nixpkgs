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
  version = "0-unstable-2026-10-16";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "0464e1c8f1f43c861a0c73d4e59437fff255cdd9";
    hash = "sha256-IXfwtENNddgUflVP4W6uEQVUQgIpvLoieFucP21hFNE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Machine code generation for C++";
    longDescription = ''
      AsmJit is a lightweight library for machine code generation written in
      C++ language. It can generate machine code for X86, X86_64, and AArch64
      architectures and supports baseline instructions and all recent
      extensions.
    '';
    homepage = "https://asmjit.com/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ thillux ];
  };
}
