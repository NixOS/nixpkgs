{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages_13,
  libxml2,
  ncurses,
  zlib,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "bfc";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Wilfred";
    repo = "bfc";
    rev = version;
    hash = "sha256-5pcvwCtXWEexvV3TS62dZ6Opg8ANP2L8B0Z8u/OQENU=";
  };

  cargoHash = "sha256-1w/jPBO1TZpa0ju+O/NxQ/oMyzIvYVoXpj+ZLcIpQoU=";

  buildInputs = [
    libxml2
    ncurses
    zlib
  ];

  env.LLVM_SYS_130_PREFIX = llvmPackages_13.llvm.dev;

  # process didn't exit successfully: <...> SIGSEGV
  doCheck = false;

  meta = with lib; {
    description = "Industrial-grade brainfuck compiler";
    mainProgram = "bfc";
    homepage = "https://bfc.wilfred.me.uk";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
}
