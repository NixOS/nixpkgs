{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-autoname-workspaces";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = finalAttrs.version;
    hash = "sha256-2pRtbzG/kGxucigK/tctCQZttf/QYZoCMnUv+6Hpi7I=";
  };

  cargoHash = "sha256-91UxBjKSg/fAtiEqvyassIzeZYUc7SYbv5N+WF0vqGM=";

  doCheck = false;

  meta = {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = lib.platforms.linux;
  };
})
