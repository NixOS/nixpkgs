{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_desktop_notifications";
  version = "0.114.1";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_desktop_notifications";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/41DHPv9UKHUY551UppiauEiwoB0qQnkSrl6pHytwLs=";
  };

  cargoHash = "sha256-csBlo1Gly1LbvMxfmydmLlzhQh7ul2haLr7IAq/GlbI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for sending desktop notifications";
    mainProgram = "nu_plugin_desktop_notifications";
    homepage = "https://github.com/FMotalleb/nu_plugin_desktop_notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
