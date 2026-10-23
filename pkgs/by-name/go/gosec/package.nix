{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gosec";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QoO+BdNFK3gPI4yES8hSGFwxAXLLj4QfBIAWxcR6HsE=";
  };

  vendorHash = "sha256-OI84VCRAkKsVB9AMmf1n20toBDhSL64By0pxssXqwwI=";

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.GitTag=${finalAttrs.src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      nilp0inter
    ];
  };
})
