{ lib, buildGoModule, fetchFromGitHub, nixosTests, testers, dex-oidc }:

buildGoModule rec {
  pname = "dex";
  version = "2.41.1";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sYTAW1S2fAAIZSFfsgYQ46TlkZHXUtbylSImBQz68DE=";
  };

  vendorHash = "sha256-LPPYJRmei/K2zW7Mi6Y/AOvNoYQSIfXKF+qxjYTCDAc=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w" "-s" "-X main.version=${src.rev}"
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
    maintainers = with maintainers; [ benley techknowlogick ];
    mainProgram = "dex";
  };
}
