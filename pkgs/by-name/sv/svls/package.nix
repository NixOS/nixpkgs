{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-DuwH0qie8SctvOGntljOdTRMGKrNFPycdaFG3QZxihA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-L+MTU92SUohhQ5Oy2ziU/1f4IxFcrW2JGUSx7iPxl/I=";

  meta = with lib; {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
