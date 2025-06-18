{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "distrobox-tui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "phanirithvij";
    repo = "distrobox-tui";
    rev = "v${version}";
    hash = "sha256-uOeJ9f2yXszGUYTxMLwvXCRkmT9Uo7mkZVhpf5HVhbg=";
  };

  vendorHash = "sha256-y64KqlJsZ8aVK7oBcduEC8VvbutoRC15LMUeZdokPfY=";

  ldflags = [ "-s" ];

  meta = {
    changelog = "https://github.com/phanirithvij/distrobox-tui/releases/tag/v${version}";
    description = "TUI for DistroBox";
    homepage = "https://github.com/phanirithvij/distrobox-tui";
    license = lib.licenses.gpl3Plus;
    mainProgram = "distrobox-tui";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
