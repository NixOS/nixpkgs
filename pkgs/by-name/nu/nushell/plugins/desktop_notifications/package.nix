{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_desktop_notifications";
  version = "0.115.0";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_desktop_notifications";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6J6CNc5NDBk5PgIbjUHjgzUXZuLX3Ws/FKtXjyxoqHo=";
  };

  cargoHash = "sha256-yQqUm3pQn4U+9U37c/XajZIvosbbraMJTujhdFi6xRI=";

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
