{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_desktop_notifications";
  version = "0.112.1";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_desktop_notifications";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QjzE0NjRgMYu85mhzCnvThfGwSv5wZIestwWt0SBHG0=";
  };

  cargoHash = "sha256-HHwbl4JdBioeM+9juTvSzMJO7uHX3NzOcKN+3YH+WZw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for sending desktop notifications";
    mainProgram = "nu_plugin_desktop_notifications";
    homepage = "https://github.com/FMotalleb/nu_plugin_desktop_notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
