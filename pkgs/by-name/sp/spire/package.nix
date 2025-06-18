{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spire";
  version = "1.12.3";

  outputs = [
    "out"
    "agent"
    "server"
  ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spire";
    rev = "v${version}";
    sha256 = "sha256-ZtSJ5/Qg4r2dkFGM/WiDWwQc2OtkX45kGXTdXU35Cng=";
  };

  vendorHash = "sha256-1ngjcqGwUNMyR/wBCo0MYguD1gGH8rbI2j9BB+tGL9k=";

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

  meta = {
    description = "SPIFFE Runtime Environment";
    homepage = "https://github.com/spiffe/spire";
    changelog = "https://github.com/spiffe/spire/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fkautz ];
  };
}
