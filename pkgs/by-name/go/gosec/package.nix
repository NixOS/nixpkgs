{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gosec";
  version = "2.29.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jajo/7GFj9eUM76PhcXbnsjVG9lDnuXE3PUV6u0Tw3c=";
  };

  vendorHash = "sha256-47+Ijb+V2xHHhvYm7h0yWouNGXDAoRgq7Y7nDwt9+Wg=";

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
