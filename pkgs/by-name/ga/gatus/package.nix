{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "gatus";
  version = "5.36.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YduXhHra6w7zo1f+brCjiusH7xCSdAzo5uF6aN5uv/A=";
  };

  vendorHash = "sha256-RbFNtojZthf7bKMhGStH/jOkeIR6EHpw2vvAMLEFtKI=";

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
