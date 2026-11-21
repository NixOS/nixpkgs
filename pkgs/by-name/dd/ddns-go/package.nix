{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ddns-go";
  version = "6.18.0";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vLhvQbgntH0pQLuvhVeoHTUP5FKq0wDOlnMhTcD5OFY=";
  };

  vendorHash = "sha256-FBEby1Tcdhb0BkHKiy9CCQwmTIisKSS2ykrHz0PpvkM=";

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
