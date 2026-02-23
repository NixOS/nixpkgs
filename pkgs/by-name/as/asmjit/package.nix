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
  version = "0-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "64a88ed1d8abb2e2b17a938a5ce7c1b66dabb695";
    hash = "sha256-NC0V5KsYNyJ/hrgAkz6oTCwQmZ8eCWNSOUl+dyTKfJk=";
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
