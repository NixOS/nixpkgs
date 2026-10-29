{
  lib,
  stdenv,
  fetchFromGitHub,

  z3,
  cmake,
  ninja,
  pkg-config,
  ocamlPackages,

  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sail-riscv";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "sail-riscv";
    rev = finalAttrs.version;
    hash = "sha256-50ATe3DQcdyNOqP85mEMyEwxzpBOplzRN9ulaJNo9zo=";
  };

  nativeBuildInputs = [
    z3
    cmake
    pkg-config
    ninja
    ocamlPackages.sail
  ];
  buildInputs = [
    gmp
  ];
  strictDeps = true;

  # sail-riscv 0.8 fails to install without compressed_changelog
  ninjaFlags = [ "compressed_changelog" ];

  meta = {
    homepage = "https://github.com/riscv/sail-riscv";
    description = "Formal specification of the RISC-V architecture, written in Sail";
    maintainers = [ ];
    license = lib.licenses.bsd2;
  };
})
