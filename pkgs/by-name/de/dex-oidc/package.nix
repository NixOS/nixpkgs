{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  testers,
  dex-oidc,
}:

buildGoModule (finalAttrs: {
  pname = "dex";
  version = "2.45.1";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = "dex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-A6PHuo3cr9m7/u/o8agOL+BiKdOKuLDvlS62O7zt/Jk=";
  };

  vendorHash = "sha256-1D20aZhNUi7MUPfRTmSV4CZjLr0lUzbX4TI2LFcPY3U=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  passthru.tests = {
    inherit (nixosTests) dex-oidc;
    version = testers.testVersion {
      package = dex-oidc;
      command = "dex version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      techknowlogick
    ];
    mainProgram = "dex";
  };
})
