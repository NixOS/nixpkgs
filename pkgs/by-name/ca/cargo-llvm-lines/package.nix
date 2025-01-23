{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.42";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-qKdxnISussiyp1ylahS7qOdMfOGwJnlbWrgEHf/L2y0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ppuc6Dx3Y4JJ8doEJPCbwnD1+dQSLRuPdWfab+3q2Ug=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    mainProgram = "cargo-llvm-lines";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${src.rev}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
