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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "vincent-uden";
    repo = "miro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HSI6sAXy+PtZdla2GMuWFwoClUIf3E4rc3NHh7Wz1BE=";
  };

  cargoHash = "sha256-yYpHB7LwGxBy5r16vzXflqaygJmibEV4XteD0BV0HoA=";

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

  env.RUSTFLAGS = toString (
    map (a: "-C link-arg=${a}") [
      "-Wl,--push-state,--no-as-needed"
      "-lEGL"
      "-lwayland-client"
      "-lxkbcommon"
      "-Wl,--pop-state"
    ]
  );

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
