{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ddns-go";
  version = "6.17.6";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AZuwKI5nwDBunt+ddShbRJQoc68DA8bwXlSAa/7k0DU=";
  };

  vendorHash = "sha256-gM9DFy4tkYAm/M0UotodIrhUn5v+aTPx8dseMz4DB4Y=";

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
