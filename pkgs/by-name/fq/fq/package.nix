{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "fq";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rGuUvuq9hZrqt3Uy1s1he8O+c+iF83RU6PsUlatrPcQ=";
  };

  vendorHash = "sha256-Iga9g9VMTxtdselFn+8udjtInXWW9sNUfSzIc7OgvbY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
})
