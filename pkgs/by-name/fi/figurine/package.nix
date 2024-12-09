{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "figurine";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "arsham";
    repo = "figurine";
    rev = "v${version}";
    hash = "sha256-1q6Y7oEntd823nWosMcKXi6c3iWsBTxPnSH4tR6+XYs=";
  };

  vendorHash = "sha256-mLdAaYkQH2RHcZft27rDW1AoFCWKiUZhh2F0DpqZELw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.currentSha=${src.rev}"
  ];

  meta = with lib; {
    homepage = "https://github.com/arsham/figurine";
    description = "Print your name in style";
    mainProgram = "figurine";
    license = licenses.asl20;
    maintainers = with maintainers; [ ironicbadger ];
  };
}
