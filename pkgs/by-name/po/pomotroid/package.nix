{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  pkg-config,
  wrapGAppsHook4,
  glib-networking,
  alsa-lib,
  webkitgtk_4_1,
  libayatana-appindicator,
  nix-update-script,
}:
let
  inlangModules = [
    (fetchurl {
      name = "plugin-message-format-index.js";
      url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js";
      hash = "sha256-IOyECYVo8YqD2jYePrrfWGImn6M1FQzJvVDXmaSP31c=";
    })
    (fetchurl {
      name = "plugin-m-function-matcher-index.js";
      url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js";
      hash = "sha256-hYYvYwV5O1a/2a/lNosJbmP7Kuqzi3eZwFFRe+NJnAs=";
    })
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pomotroid";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "Splode";
    repo = "pomotroid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ENpB364AJ8abDiocNyVpVS2kbRk41Bd0fAGfvY+Zsq0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hF+8G/RM+0PwWn/rvJCR0DfuCcsYoGBYAg3R955Iq0I=";
  };

  cargoHash = "sha256-8hwg/kysxm7bNE0CrUh5bqVAHNAU5poqcHsouyDV1wU=";

  postPatch = ''
    # paraglide plugins must be available offline
    substituteInPlace project.inlang/settings.json ${
      lib.concatMapStringsSep " " (m: "--replace-fail ${m.url} ${m}") inlangModules
    }

    # fetchFromGitHub has no .git metadata, so don't show "+unknown"
    substituteInPlace src-tauri/build.rs \
      --replace-fail \
        'None => format!("{base_version}+unknown"),' \
        'None => base_version.clone(),'

    # nixpkgs handles updates
    substituteInPlace src-tauri/src/settings/defaults.rs \
      --replace-fail \
        '("check_for_updates", "true")' \
        '("check_for_updates", "false")'

    # Disable update checking and hide update status/install UI in the About page
    substituteInPlace src/lib/components/settings/sections/AboutSection.svelte \
      --replace-fail \
        'if ($settings.check_for_updates) {' \
        'if (false) {' \
      --replace-fail \
        "{#if \$settings.check_for_updates || updateState !== 'idle'}" \
        "{#if false}"

    # Remove update preference from Settings
    substituteInPlace src/lib/components/settings/sections/SystemSection.svelte \
      --replace-fail \
        $'  <div class="group-heading">{m.system_group_updates()}</div>\n\n  <SettingsToggle\n    label={m.system_toggle_check_updates()}\n    description={m.system_toggle_check_updates_desc()}\n    checked={$settings.check_for_updates}\n    onclick={() => toggle(\'check_for_updates\', $settings.check_for_updates)}\n  />' \
        ""
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    glib-networking
    libayatana-appindicator
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libayatana-appindicator
        ]
      }
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and visually pleasing Pomodoro timer";
    homepage = "https://github.com/Splode/pomotroid";
    changelog = "https://github.com/Splode/pomotroid/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nyxar77 ];
    mainProgram = "pomotroid";
    inherit (cargo-tauri.hook.meta) platforms;
  };
})
