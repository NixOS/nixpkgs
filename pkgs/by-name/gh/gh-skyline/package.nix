{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gh-skyline";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-skyline";
    tag = "v${version}";
    hash = "sha256-IMsq+IhuZUJ7JSWZJPvx2bQ9avFsjfc/kOW9Sre5jAo=";
  };

  vendorHash = "sha256-iAqc8RlvpvP9Go8E/b+PnEgKRdpD3+IIQ1JUKVZ1Ces=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a 3D model of your GitHub contribution history";
    homepage = "https://github.com/github/gh-skyline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ perchun ];
    mainProgram = "gh-skyline";
  };
}
