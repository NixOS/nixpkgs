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
  version = "2.44.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = "dex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wpy7pZBpqAaPjWbnsqtnE+65a58IGg0pyp4CEUnmmc4=";
  };

  vendorHash = "sha256-3ef2G4+UlLGsBW09ZM20qU82uj/hVlMAnujcd2BulGg=";

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

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      techknowlogick
    ];
    mainProgram = "dex";
  };
})
