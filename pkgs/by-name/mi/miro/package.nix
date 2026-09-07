{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  fontconfig,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miro";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "vincent-uden";
    repo = "miro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aCXPaUir4sd27S9CEdPbgaas2mstAxONcIWmZMpX6a8=";
  };

  cargoHash = "sha256-/XlkdtZNx05WgdlHZ2WWUrjadiAUJz6x25jSKiO/H34=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native PDF viewer (Wayland/X11) with configurable keybindings";
    homepage = "https://github.com/vincent-uden/miro";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "miro-pdf";
  };
})
