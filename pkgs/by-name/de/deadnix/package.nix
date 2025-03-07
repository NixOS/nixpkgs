{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    hash = "sha256-xaaXGzTd+t1GjD2KpiS/c8acv6bXufv/lTN+ACRGVJw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-unp5W2vatSS58O+nEAVsVBN99hgYRVc1OkD2vVandw0=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    mainProgram = "deadnix";
    maintainers = with maintainers; [ astro ];
  };
}
