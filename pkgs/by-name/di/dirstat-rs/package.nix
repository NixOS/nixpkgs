{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dirstat-rs";
  version = "0.3.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scullionw";
    repo = "dirstat-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gDIUYhc+GWbQsn5DihnBJdOJ45zdwm24J2ZD2jEwGyE=";
  };

  cargoHash = "sha256-SdxTiIrsK3U4mcrcilOhMkkp12yEUkWlXmlT+C75dZw=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Disk usage CLI";
    homepage = "https://github.com/scullionw/dirstat-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alinnow ];
    mainProgram = "ds";
    platforms = with lib.platforms; unix ++ windows;
  };
})
