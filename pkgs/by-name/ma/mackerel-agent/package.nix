{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  iproute2,
  net-tools,
}:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.85.3";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-agent";
    rev = "v${version}";
    sha256 = "sha256-dWNZDw5In2vBtE4aGnMEoIpwdhZOSUVBWCq5fqBwiCo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ net-tools ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ iproute2 ];

  vendorHash = "sha256-klWrfA7bYAGaurH1HQ0/CdLbvUpQ7uPKrgiEUarw+20=";

  subPackages = [ "." ];

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.gitcommit=v${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/mackerel-agent \
      --prefix PATH : "${lib.makeBinPath buildInputs}"
  '';

  doCheck = true;

  meta = {
    description = "System monitoring service for mackerel.io";
    mainProgram = "mackerel-agent";
    homepage = "https://github.com/mackerelio/mackerel-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ midchildan ];
  };
}
