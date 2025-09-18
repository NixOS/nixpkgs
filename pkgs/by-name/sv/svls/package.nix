{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-kxsB7il2KKjxSUoA+e6tSNQHwGGVO4UB/mAfnDPjb0c=";
  };

  cargoHash = "sha256-2SOCv8xeaRVlpJrBd9po5KgNY7ZSraw4UNsE0gRTbLs=";

  meta = with lib; {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
