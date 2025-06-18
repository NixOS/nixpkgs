{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "marathonctl";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "shoenig";
    repo = "marathonctl";
    rev = "v${version}";
    sha256 = "sha256-MigmvOwYa0uYPexchS4MP74I1Tp6QHYuQVSOh1+FrMg=";
  };

  vendorHash = "sha256-Oiol4KuPOyJq2Bfc5div+enX4kQqYn20itmwWBecuIg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/shoenig/marathonctl";
    description = "CLI tool for Marathon";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
    mainProgram = "marathonctl";
  };
}
