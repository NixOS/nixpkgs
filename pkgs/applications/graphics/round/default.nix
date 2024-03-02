{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "round";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vP2q0inU5zNJ/eiAqEzwHSqril8hTtpbpNBiAkeWeSU=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Round image corners from CLI";
    homepage    = "https://github.com/mingrammer/round";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
    mainProgram = "round";
  };
}
