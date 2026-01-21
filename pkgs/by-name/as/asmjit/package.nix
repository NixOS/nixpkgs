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
  version = "0-unstable-2026-01-03";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "f64c90818ff2ef87ec4f73f44d0a7e73fbff3229";
    hash = "sha256-+tDWV25KxC+0hhnyC/9b7ixpP7PZsUHzTZB8KmpWtO8=";
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
