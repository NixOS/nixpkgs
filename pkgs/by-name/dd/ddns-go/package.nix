{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ddns-go";
  version = "6.17.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-si1+L523iXBhH/Jo7zm0M/zT5d/hrZvDTYS4WMaFdSQ=";
  };

  vendorHash = "sha256-MbITJ2MxyTNE6LS9rQZ10IVgQuXpmbPf5HQgoy2OuOc=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  # network required
  doCheck = false;

  meta = {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "ddns-go";
  };
})
