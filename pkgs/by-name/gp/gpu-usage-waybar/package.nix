{
  lib,
  fetchFromGitHub,
  rustPlatform,
  autoAddDriverRunpath,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpu-usage-waybar";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "PolpOnline";
    repo = "gpu-usage-waybar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RGSPOuhxF2JcfmifCfvslXr46cN+XpgjnS4z7pbLbBc=";
  };

  cargoHash = "sha256-FsH8WtgkHeD3PrU2oBIyQdqouTmKO7amTE3tZRAPpqE=";

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  meta = {
    description = "Tool to display GPU usage in Waybar";
    homepage = "https://github.com/PolpOnline/gpu-usage-waybar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nouritsu ];
    mainProgram = "gpu-usage-waybar";
    platforms = lib.platforms.linux;
  };
})
