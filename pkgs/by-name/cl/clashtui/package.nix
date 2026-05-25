{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clashtui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "JohanChane";
    repo = "clashtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZYGGlTBox7ChdBwvMWTHqys/WQ0heBXpXa6XIrurp60=";
  };

  cargoHash = "sha256-C71OkwEJSYoBPqDP6QJBWvOZlVxOlg3yBDAq9FRmBmo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mihomo (Clash.Meta) / sing-box TUI Client";
    homepage = "https://github.com/JohanChane/clashtui";
    changelog = "https://github.com/JohanChane/clashtui/releases/tag/v${finalAttrs.version}";
    mainProgram = "clashtui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
