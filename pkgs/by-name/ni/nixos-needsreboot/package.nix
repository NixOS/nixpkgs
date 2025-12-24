{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixos-needsreboot";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "fredclausen";
    repo = "nixos-needsreboot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KnDDF+K6C3Pj/b/o30lTRNUxDq4SwZU1K17zsrrOT4=";
  };

  cargoHash = "sha256-KiYDU9FRRy/xsnz8KI5eDsySifDJAEc7MieArCUC7FI=";

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Determine whether a NixOS system requires a reboot based on kernel and service changes";
    homepage = "https://github.com/fredclausen/nixos-needsreboot";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fredclausen ];
    platforms = lib.platforms.linux;
  };
})
