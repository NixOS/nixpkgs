{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "gatus";
  version = "5.38.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ols3YIqrrpZk+aNc5o5mCtvS2YDkqhMsIrL57YA7pLo=";
  };

  vendorHash = "sha256-/IfnwjAtBK0qlGQz7uqGzQ0nw7emW7jdptEMYoTMSoQ=";

  subPackages = [ "." ];

  passthru.tests = {
    inherit (nixosTests) gatus;
  };

  meta = {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ undefined-moe ];
    mainProgram = "gatus";
  };
})
