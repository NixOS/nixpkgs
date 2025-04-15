{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spire";
  version = "1.12.0";

  outputs = [
    "out"
    "agent"
    "server"
  ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hNa1e6h4IhD2SfhZZ5xkwQ7e7X5x3Gk4v33nw2t+cvk=";
  };

  vendorHash = "sha256-6qtR9SF6QQKqsVpKpp6YBkB9wOLFwm8C3PF0DlN0Ud0=";

  subPackages = [
    "cmd/spire-agent"
    "cmd/spire-server"
  ];

  # Usually either the agent or server is needed for a given use case, but not both
  postInstall = ''
    mkdir -vp $agent/bin $server/bin
    mv -v $out/bin/spire-agent $agent/bin/
    mv -v $out/bin/spire-server $server/bin/

    ln -vs $agent/bin/spire-agent $out/bin/spire-agent
    ln -vs $server/bin/spire-server $out/bin/spire-server
  '';

  meta = with lib; {
    description = "SPIFFE Runtime Environment";
    homepage = "https://github.com/spiffe/spire";
    changelog = "https://github.com/spiffe/spire/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fkautz ];
  };
}
