{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  iproute2,
  nettools,
}:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.85.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-agent";
    rev = "v${version}";
    sha256 = "sha256-wTL+zxa0uaRT8cP2P+iYW6qC8RS5g8wSpvsa01iSUXA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ iproute2 ];

  vendorHash = "sha256-Q3HsfLA6xqzwXVfRc0bOb15kW2tdwj14DvJEZoRy0/4=";

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

  meta = with lib; {
    description = "System monitoring service for mackerel.io";
    mainProgram = "mackerel-agent";
    homepage = "https://github.com/mackerelio/mackerel-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ midchildan ];
  };
}
