{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  fontconfig,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miro";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "vincent-uden";
    repo = "miro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-znrbAufYM+YIPm0oSZ8i4vHHrhlgSQWMzKfqdF8qaow=";
  };

  cargoHash = "sha256-VP2RUKTQM2AkXY/KgN0tjWXF7SQ24geAvxEQJitH23I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native PDF viewer (Wayland/X11) with configurable keybindings";
    homepage = "https://github.com/vincent-uden/miro";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "miro";
  };
})
