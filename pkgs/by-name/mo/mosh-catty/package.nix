{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mosh-catty";
  version = "0.1.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "binaricat";
    repo = "MoshCatty";
    tag = "moshcatty-${finalAttrs.version}";
    hash = "sha256-o+ObAwLRTWHCRo309fke6SmLG1xy9ZtKxhqDnU3Qa9s=";
  };

  cargoHash = "sha256-NElulYceiLjGhg9qmYWkT6kUyhhCyH4yce5tjDa3uv0=";

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pure Rust Mosh client, wire-compatible with stock mosh-server";
    homepage = "https://github.com/binaricat/MoshCatty";
    changelog = "https://github.com/binaricat/MoshCatty/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "mosh-client";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
