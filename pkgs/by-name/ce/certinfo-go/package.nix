{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "certinfo-go";
  version = "0.1.55";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L7gX6GaNI2tqLf7diCBOXDWtP2bQJYI//ZKQ/76J+ZA=";
  };

  vendorHash = "sha256-SuQGgPT9ItoJPca6f8hsARwlpPwwb2avszZFBBp6LBA=";

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
