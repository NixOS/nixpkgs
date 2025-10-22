{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "round";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = "round";
    rev = "v${version}";
    hash = "sha256-vP2q0inU5zNJ/eiAqEzwHSqril8hTtpbpNBiAkeWeSU=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = {
    description = "CLI tool for rounding images";
    homepage = "https://github.com/mingrammer/round";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ addict3d ];
    mainProgram = "round";
  };
}
