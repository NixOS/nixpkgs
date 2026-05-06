{
  stdenv,
  lib,
  libsoup_3,
  dbus,
  glib,
  glib-networking,
  librsvg,
  webkitgtk_4_1,
  pkg-config,
  cargo-tauri,
  wrapGAppsHook3,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  mono,
  jq,
  wrapWithMono ? true,
  nix-update-script,
}:
let
  pname = "owmods-gui";
  version = "0.15.6";
  src = fetchFromGitHub {
    owner = "ow-mods";
    repo = "ow-mod-man";
    tag = "gui_v${version}";
    hash = "sha256-2jf9yjvWvE6If2ChdbgdLwSJtyj4AYSKkV9E7jgQ3G8=";
  };
  frontend = buildNpmPackage {
    pname = "owmods-gui-ui";
    inherit version;

    env.VITE_VERSION_SUFFIX = "-nix";

    src = "${src}/owmods_gui/frontend";

    packageJSON = "${src}/owmods_gui/frontend/package.json";
    npmDepsHash = "sha256-Ske3EFiLDPMLI2ln65pZL22pExT/OfT0v0x+TxiZjQo=";

    postBuild = ''
      cp -r ../dist/ $out
    '';
    distPhase = "true";
    dontInstall = true;
    installInPlace = true;
    distDir = "../dist";

    meta = {
      description = "Web frontend for the Outer Wilds Mod Manager";
      homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_gui/frontend";
      license = lib.licenses.gpl3Plus;
    };
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-UsqkamsWyJ+SUOD8Ab0wZIfcL6NBe0kKbLXSm7rFOGM=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "custom-protocol"
  ];

  nativeBuildInputs = [
    cargo-tauri.hook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libsoup_3
    glib
    librsvg
    glib-networking
    webkitgtk_4_1
  ];

  buildAndTestSubdir = "owmods_gui/backend";

  preFixup = lib.optionalString (
    stdenv.hostPlatform.isLinux && wrapWithMono
  ) "gappsWrapperArgs+=(--prefix PATH : '${mono}/bin')";

  postPatch = ''
    ${lib.getExe jq} \
      'del(.plugins.tauri.updater) | .build.frontendDist = "${frontend}" | del(.build.beforeBuildCommand) | .bundle.createUpdaterArtifacts = false' owmods_gui/backend/tauri.conf.json > owmods_gui/backend/new.tauri.conf.json;
    mv owmods_gui/backend/new.tauri.conf.json owmods_gui/backend/tauri.conf.json
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/Outer Wilds Mod Manager.app/Contents/MacOS/owmods_gui" "$out/bin/owmods_gui" ${lib.optionalString wrapWithMono "--set MONO_BINARY ${lib.getExe mono}"}
  '';

  passthru = {
    inherit frontend;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
        "--version-regex"
        "gui_v(.*)"
      ];
    };
  };

  meta = {
    description = "GUI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_gui";
    downloadPage = "https://github.com/ow-mods/ow-mod-man/releases/tag/gui_v${version}";
    changelog = "https://github.com/ow-mods/ow-mod-man/releases/tag/gui_v${version}";
    mainProgram = "owmods_gui";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bwc9876
      locochoco
      spoonbaker
    ];
  };
}
