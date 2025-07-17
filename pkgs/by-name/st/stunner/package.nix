{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.0.8";
in
buildGoModule {
  pname = "stunner";
  inherit version;

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "stunner";
    tag = "v${version}";
    hash = "sha256-jZNM58aP2hBfuAIFjSCwdBkCbDA5KDTlZV8AkoWnhD4=";
  };

  vendorHash = "sha256-arWRaTqaN6Ji6MjTZdp8J7bs6NjbdY7YkueKMBdAAts=";

  ldflags = [
    "-X=main.Version=${version}"
  ];

  meta = {
    description = "Detect your NAT quickly and easily, and that's the bottom line";
    longDescription = ''
      Stunner is a small Go CLI tool that sends STUN Binding Requests to
      multiple Tailscale DERP servers (or any STUN servers you specify) and
      reports the resulting NAT classification. This helps you determine
      whether you're behind a Full Cone, Symmetric NAT, Restricted, or
      otherwise, by analyzing how multiple STUN servers perceive your external
      IP/port mapping.
    '';
    homepage = "https://github.com/jaxxstorm/stunner";
    changelog = "https://github.com/jaxxstorm/stunner/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "stunner";
  };
}
