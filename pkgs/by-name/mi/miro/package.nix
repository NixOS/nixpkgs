{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  wayland,
  libxkbcommon,
  libglvnd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miro";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "vincent-uden";
    repo = "miro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tkZSyxdcHeumBMlinwA3DT2Y/FgLzbeuVbsFbTfvINg=";
  };

  cargoHash = "sha256-4NE9nMmOTQpWvMsGexW6GpBGao4yQoofrzGaaM4+rWE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    wayland
    fontconfig
    libxkbcommon
    libglvnd
  ];

  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-lxkbcommon"
    "-Wl,--pop-state"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native PDF viewer (Wayland/X11) with configurable keybindings";
    homepage = "https://github.com/vincent-uden/miro";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "miro-pdf";
  };
})
