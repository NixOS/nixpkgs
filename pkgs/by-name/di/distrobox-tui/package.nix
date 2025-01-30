{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "distrobox-tui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "phanirithvij";
    repo = "distrobox-tui";
    rev = "v${version}";
    hash = "sha256-J5stvhUNaU9YMczE56vC5bw2g67zsdVWiCi8k6KV/pU=";
  };

  vendorHash = "sha256-F7X3FBM/F0uPxbM3en0sk9a58O/meKnVsASgIlL7FCo=";

  ldflags = [ "-s" ];

  meta = with lib; {
    description = "A TUI for DistroBox";
    changelog = "https://github.com/phanirithvij/distrobox-tui/releases/tag/v${version}";
    homepage = "https://github.com/phanirithvij/distrobox-tui";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "distrobox-tui";
  };
}
