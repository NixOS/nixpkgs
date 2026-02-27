{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "certinfo-go";
  version = "0.1.51";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8CN3mu7xLSXDQ4nTVlJSCZwDCRQyUGE3oIdJTbpWKzQ=";
  };

  vendorHash = "sha256-VU40TmdABNbbROl9kL0m+k2ITBiPfs5CaXB3Ntd89ig=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
