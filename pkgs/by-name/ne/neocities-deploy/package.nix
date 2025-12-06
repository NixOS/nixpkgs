{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "neocities-deploy";
  version = "0.1.20";
  src = fetchFromGitHub {
    owner = "kugland";
    repo = "neocities-deploy";
    rev = "v${version}";
    hash = "sha256-m5uC4HiT4uHaXOt0NdXkd/eM/VRWBaqpW2tgeBPKGbs=";
  };
  cargoHash = "sha256-WJFOmxCOsduxDwj0KTga/oi6hCE/UJ1Je6wxtrKz+EY=";
  doCheck = false; # This package tests are impure
  meta = with lib; {
    description = "A command-line tool for deploying your Neocities site";
    homepage = "https://github.com/kugland/neocities-deploy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kugland ];
    mainProgram = "neocities-deploy";
    platforms = platforms.all;
  };
}
