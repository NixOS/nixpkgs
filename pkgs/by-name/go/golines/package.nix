{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "golines";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golines";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3oLSlwKaJQVtM2INiU56WaCGsEzDVDLxiahBN+3IzkY=";
  };

  vendorHash = "sha256-MCoRDIG3M+xtgaY6/7W066ZxTarMV5bo/lUtxiHeNfs=";

  subPackages = [
    "."
  ];

  meta = {
    description = "Golang formatter that fixes long lines";
    homepage = "https://github.com/golangci/golines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "golines";
  };
})
