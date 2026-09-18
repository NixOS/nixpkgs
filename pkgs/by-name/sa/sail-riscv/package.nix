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
  cli11,
  jsoncons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sail-riscv";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "sail-riscv";
    tag = finalAttrs.version;
    hash = "sha256-pi/XP6+NX/wNpBESmnEg2d5cppMpMwFripDPk9vTx9I=";
  };

  patches = [
    ./unvendor-deps.patch
  ];

  nativeBuildInputs = [
    z3
    cmake
    pkg-config
    ninja
    ocamlPackages.sail
  ];
  buildInputs = [
    gmp
    # Header-only
    jsoncons
    cli11
  ];
  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LTO" true)
  ];

  meta = {
    homepage = "https://github.com/riscv/sail-riscv";
    description = "Formal specification of the RISC-V architecture, written in Sail";
    maintainers = with lib.maintainers; [
      xokdvium
    ];
    license = lib.licenses.bsd2;
  };
})
