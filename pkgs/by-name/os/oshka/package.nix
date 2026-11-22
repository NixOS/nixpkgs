{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oshka";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "oshka";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fpWhqFK5h/U7DCC/SyhAlMyCMhjZHRLMlwakvlhOd3w=";
  };

  vendorHash = "sha256-ZBI3WDXfJKBEF2rmUN3LvOOPT1185dHmj88qJKsdUiE=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/k1LoW/oshka/version.Version=${finalAttrs.version}"
  ];

  # Tests requires a running Docker instance
  doCheck = false;

  meta = {
    description = "Tool for extracting nested CI/CD supply chains and executing commands";
    mainProgram = "oshka";
    homepage = "https://github.com/k1LoW/oshka";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
