{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-flatland";
  version = "0.50.1-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "flatland";
    rev = "599c7b11eae996ae02a4706bd281bde19254dfd2";
    hash = "sha256-CkohNzi3zXG5yW5c++GDZtrUqqpjEQskL8gpOTKNMZc=";
  };

  env.STARDUST_RES_PREFIXES = "${finalAttrs.src}/res";

  cargoHash = "sha256-QBhIb5RxZh80gY3gj/+6ul3h0Qkptt53Q41+mn81ciY=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Flat window for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "flatland";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
})
