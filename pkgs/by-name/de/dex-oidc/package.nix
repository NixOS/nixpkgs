{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nixosTests,
  testers,
  dex-oidc,
}:

buildGo124Module rec {
  pname = "dex";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = "dex";
    rev = "v${version}";
    sha256 = "sha256-FbjNOyECgf26+Z48YwF9uMN8C3zMRshD3VOjoRbA0ys=";
  };

  vendorHash = "sha256-D8UMrQcUntsXV1PFOk30NhmJ9f17M58D79VDdbybt7Q=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${src.rev}"
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
      version = "v${version}";
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
}
