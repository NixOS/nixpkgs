{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule {
  pname = "dnss";
  version = "0-unstable-2024-03-17";
  src = fetchFromGitHub {
    owner = "albertito";
    repo = "dnss";
    rev = "da8986dd432870f5710e3e8652c92c95f34b830b";
    hash = "sha256-YjBt+22fc9yHcORRmd//rejNVvf6eK+FAYAcT0fABuI=";
  };

  vendorHash = "sha256-d9aGSBRblkvH5Ixw3jpbgC8lMW/qEYNJfLTVeUlos7A=";

  meta = with lib; {
    description = "Daemon for using DNS over HTTPS";
    homepage = "https://blitiri.com.ar/git/r/dnss/";
    license = licenses.asl20;
    mainProgram = "dnss";
    maintainers = with maintainers; [ raspher ];
  };
}
