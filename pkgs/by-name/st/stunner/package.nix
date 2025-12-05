{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.0.12";
in
buildGoModule {
  pname = "stunner";
  inherit version;

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "stunner";
    tag = "v${version}";
    hash = "sha256-f45MliWauAkUkffcoexRz+ZjWUYmhZ6yVKqqdC56V04=";
  };

  vendorHash = "sha256-tO61UBZxPBg6oFKOuMjPSb4EHZ9wPAyBsdQZb7DLdw0=";

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
