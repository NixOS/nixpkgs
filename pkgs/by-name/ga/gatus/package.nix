{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "gatus";
  version = "5.37.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t/XKrXBMf9r6Nrctyc4ZgB8elybhDh8dAV4ATjdNJpo=";
  };

  vendorHash = "sha256-W0m2lRyHW++XknHW/gn4Vye55hZY4BWsC5ZT9joufeA=";

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
