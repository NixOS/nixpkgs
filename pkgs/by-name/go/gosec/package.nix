{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gosec";
  version = "2.24.7";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a350HsTvcXEmJC6mWF4kF2RuZ3LwS0buFMwpFi+nCSQ=";
  };

  vendorHash = "sha256-anuAY4Z9rEOlkdNEcCCySW3ci79OdhiuhH+/uXX/6sU=";

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
