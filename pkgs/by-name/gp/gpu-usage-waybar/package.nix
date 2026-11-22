{
  lib,
  fetchFromGitHub,
  rustPlatform,
  autoAddDriverRunpath,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpu-usage-waybar";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "PolpOnline";
    repo = "gpu-usage-waybar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8kj5QQ7yknLct6PfVGz+TiSS6nmQPzDXt2LF0h1hMNE=";
  };

  cargoHash = "sha256-wGKMZDT+B/AD8onnfslnqKBFgqVJNo/idWKLZOiQb/c=";

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
