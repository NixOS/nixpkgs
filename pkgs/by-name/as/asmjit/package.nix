{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  lib,
}:

stdenv.mkDerivation {
  pname = "asmjit";
  version = "unstable-2023-04-28";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "3577608cab0bc509f856ebf6e41b2f9d9f71acc4";
    hash = "sha256-EIfSruaM2Z64XOYAeEaf/wFy6/7UO6Sth487R1Q0yhI=";
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
    maintainers = with maintainers; [ nikstur ];
  };
}
