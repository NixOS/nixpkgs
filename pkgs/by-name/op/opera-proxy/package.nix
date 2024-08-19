{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "opera-proxy";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Snawoot";
    repo = "opera-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-vQlf5wDmREhASZ0wn9LmJkHH9De86gRoyxQ3uvZ+Huo=";
  };

  vendorHash = "sha256-b2rhXChEpMkC9L+12K1NmbAOoSLJH95t8p0mI22zHxw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Standalone client for proxies of Opera VPN";
    homepage = "https://github.com/Snawoot/opera-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "opera-proxy";
  };
}
