{
  alsa-lib,
  cargo-tauri,
  clang,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  lib,
  libappindicator,
  libappindicator-gtk3,
  libayatana-appindicator,
  llvmPackages,
  makeWrapper,
  nix-update-script,
  nodejs,
  npmHooks,
  openssl,
  pipewire, # pw-metadata for bit-perfect sample rate queries
  pkg-config,
  pulseaudio, # pactl for PipeWire device enumeration and sink routing
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qbz";
  version = "1.2.15";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G7wR5HV0qwlrCPmKTv68+EeDTTyCAvvmPr7GDhrwTaA=";
  };

  cargoHash = "sha256-nF3hoKn6NA5uuRLgKit83Yxqrc0r+/IaI+xFjrw+oG8=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  tauriBuildFlags = [ "--no-sign" ];

  npmDeps = fetchNpmDeps {
    name = "qbz-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-RIR3erHN27fU9tTNQdUK0/5QDS9Dgd+O03PfqlYfRcM=";
  };

  env.LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  nativeBuildInputs = [
    cargo-tauri.hook
    clang
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    libappindicator-gtk3
    openssl
    webkitgtk_4_1
  ];

  doCheck = false;

  postInstall = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          pulseaudio
          pipewire
        ]
      }
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libappindicator
          libayatana-appindicator
        ]
      }
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A native, full-featured hi-fi Qobuz desktop player for Linux, with fast, bit-perfect audio playback";
    homepage = "https://qbz.lol";
    changelog = "https://github.com/vicrodh/qbz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    mainProgram = "qbz";
    platforms = lib.platforms.linux;
  };
})
