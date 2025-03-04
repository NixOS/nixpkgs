{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "managarr";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${version}";
    hash = "sha256-VWlKfot6G97H7o1JhcAQgAjhYr2hvPrez1ZkeniWYBQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bddsQlPsVXrhKoitEmxb2fZIoq4ePsVCGBN1y5hMn2U=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.IncredibleLaser ];
    mainProgram = "managarr";
  };
}
