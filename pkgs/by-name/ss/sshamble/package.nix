{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (rec {
  pname = "sshamble";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "runZeroInc";
    repo = "sshamble";
    tag = "v${version}";
    hash = "sha256-EKz7Jz+kILVphpmLhkF4wz43LItGYzXfQGXL2EO8ulw=";
  };

  vendorHash = "sha256-8p7livwkZ9TYl/4rhWeyKS08z9QkfIV5vAgshFyUi98=";

  doCheck = false; # tries to download from the Internet

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "SSH-protocol pentesting utility";
    homepage = "https://github.com/runZeroInc/sshamble";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ YoshiRulz ];
    mainProgram = "sshamble";
  };
})
