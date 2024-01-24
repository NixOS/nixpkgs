{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "gow";
  version = "unstable-2023-10-26";

  src = fetchFromGitHub {
    owner = "mitranim";
    repo = "gow";
    rev = "af11a6e1e9ebccdcdace2a6df619355b85494d74";
    hash = "sha256-NmjJd3GVImCtYo5CxGnQHHPERx5R0sD4bzBsbxNGc3o=";
  };

  vendorHash = "sha256-Xw9V7bYaSfu5kA2505wmef2Ns/Y0RHKbZHUkvCtVNSM=";

  meta = with lib; {
    description = "Missing watch mode for Go commands. Watch Go files and execute a command like 'go run' or 'go test'";
    homepage = "https://github.com/mitranim/gow";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.unlicense;
    maintainers = with maintainers; [ endocrimes ];
    mainProgram = "gow";
  };
}
