{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "cruise";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "NucleoFusion";
    repo = "cruise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AhLSzynNvtHK3URTd1034/2ToGcJUDp7rGMtr3kyees=";
  };

  vendorHash = "sha256-Zx1rZl5ljlsBNV1eQKPtQ+SgJV9l5rS8hwBe8nX9dYQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for managing Docker containers, images, volumes, networks, and more";
    homepage = "https://github.com/NucleoFusion/cruise";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greatnatedev ];
    mainProgram = "cruise";
    platforms = lib.platforms.linux;
  };
})
