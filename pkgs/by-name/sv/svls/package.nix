{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
<<<<<<< HEAD
  version = "0.2.14";
=======
  version = "0.2.13";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dLAlXsvUno6bx67A3knevo0ZRBMNOlWW3CmNfgCgha4=";
  };

  cargoHash = "sha256-7q6VeMjnDE4N35Kk6w4T9Za2VquibuvitGVWTvHvvgs=";

  meta = {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ trepetti ];
=======
    sha256 = "sha256-kxsB7il2KKjxSUoA+e6tSNQHwGGVO4UB/mAfnDPjb0c=";
  };

  cargoHash = "sha256-2SOCv8xeaRVlpJrBd9po5KgNY7ZSraw4UNsE0gRTbLs=";

  meta = with lib; {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
