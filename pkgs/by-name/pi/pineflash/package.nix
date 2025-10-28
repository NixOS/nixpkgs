{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  autoPatchelfHook,
  blisp,
  dfu-util,
  fontconfig,
  glib,
  gtk3,
  openssl,
  systemd,
  libGL,
  libxkbcommon,
  nix-update-script,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pineflash";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Spagett1";
    repo = "pineflash";
    tag = finalAttrs.version;
    hash = "sha256-4tcwEok36vuXbtlZNUkLNw1kHFQPBEJM/gWRhRWNLPg=";
  };

  cargoHash = "sha256-OgUWOtqgGCRNYCrdMa8IAfxbbYqv+1WwubvfYybuAQU=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = [
    blisp
    dfu-util
    fontconfig
    glib
    gtk3
    openssl
    systemd
  ];

  runtimeDependencies = [
    libGL
    libxkbcommon
    wayland
  ];

  postPatch = ''
    substituteInPlace src/submodules/flash.rs \
      --replace-fail 'let command = Command::new("pkexec")' 'let command = Command::new("/run/wrappers/bin/pkexec")'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/submodules/flash.rs \
      --replace-fail 'let blisppath = "blisp";' 'let blisppath = "${lib.getExe blisp}";' \
      --replace-fail 'let dfupath = "dfu-util";' 'let dfupath = "${lib.getExe' dfu-util "dfu-util"}";'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/submodules/flash.rs \
      --replace-fail 'Command::new("blisp")' 'Command::new("${lib.getExe blisp}")' \
      --replace-fail 'Command::new("dfu-util")' 'Command::new("${lib.getExe' dfu-util "dfu-util"}")'
  '';

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp ./assets/Pineflash.desktop "$out/share/applications/Pineflash.desktop"
    mkdir -p "$out/share/pixmaps"
    cp ./assets/pine64logo.png "$out/share/pixmaps/pine64logo.png"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GUI tool to flash IronOS to the Pinecil V1 and V2";
    homepage = "https://github.com/Spagett1/pineflash";
    changelog = "https://github.com/Spagett1/pineflash/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "pineflash";
  };
})
