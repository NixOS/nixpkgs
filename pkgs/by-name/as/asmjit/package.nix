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
  version = "0-unstable-2025-12-09";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "0cf6eafda249fc99cee2df0fb57a5c5f38e92f93";
    hash = "sha256-PBsygYaIS45t2Br3YnIEbNSQcvxuL8JdUaDoHI/2tRY=";
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
