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
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "5fe1940275d04432da841896bac0a66cc2375551";
    hash = "sha256-Oj8VP9rJXHQYP3aV8sm+XbyHXLvmC+7e+OGy5YQqFzQ=";
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
