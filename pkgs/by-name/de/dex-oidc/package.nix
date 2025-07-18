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
  version = "2.43.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = "dex";
    rev = "v${version}";
    sha256 = "sha256-ELklXlB691xcUdCi+B1Vwd9yvS1Txg+X+QKBMGP8354=";
  };

  vendorHash = "sha256-td15lXx6h4SFfTQdc4Whe2bbOpXK57OD8fyDzRvas8M=";

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
