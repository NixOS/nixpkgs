{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.31.1-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    hash = "sha256-OJWf96Dq06U56dIMMocGYgyZdu94VM3A6ViJZR+gbxQ=";
  };

  vendorHash = "sha256-TnnYjTbN6zuXUbZbh1sK9bmjR7FleFqNFrqwBTllypY=";

  subPackages = [
    "cmd/loop"
    "cmd/loopd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [
      proofofkeags
      prusnak
    ];
  };
}
