{
  bun,
  cargo,
  cargo-tauri,
  dbus,
  glib,
  glib-networking,
  gst_all_1,
  gtk3,
  jq,
  lib,
  libappindicator-gtk3,
  librsvg,
  libsoup_3,
  makeBinaryWrapper,
  opencode,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  stdenvNoCC,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  gtk = gtk3;
  libappindicator-gtk = libappindicator-gtk3;
  libsoup = libsoup_3;
  webkitgtk = webkitgtk_4_1;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opencode-desktop";
  inherit (opencode)
    version
    src
    patches
    ;

  bunWorkspaces = [ "./packages/desktop" ];
  bunDeps = bun.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      bunWorkspaces
      ;
    hash = "";
  };

  cargoRoot = "packages/desktop/src-tauri";
  cargoHash = "sha256-WI48iYdxmizF1YgOQtk05dvrBEMqFjHP9s3+zBFAat0=";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    pkg-config
    cargo-tauri.hook
    bun.configHook
    cargo
    rustc
    jq
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = (
    lib.optionals stdenvNoCC.isLinux [
      dbus
      glib
      glib-networking
      gtk
      libappindicator-gtk
      librsvg
      libsoup
      openssl
      webkitgtk
    ]
    ++ (with gst_all_1; [
      gst-plugins-bad # fakevideosink
      gst-plugins-base # appsink and autoaudiosink
      gst-plugins-good # autoaudiosink
    ])
  );

  tauriBuildFlags = [
    "--config"
    "tauri.conf.json"
    "--config"
    "tauri.prod.conf.json"
    "--no-sign"
  ];

  preBuild = ''
    install -D ${lib.getExe opencode} \
      packages/desktop/src-tauri/sidecars/opencode-cli-${stdenvNoCC.hostPlatform.rust.rustcTarget}
  '';

  meta = {
    description = "AI coding agent desktop client";
    homepage = "https://opencode.ai";
    inherit (opencode.meta) platforms;
    license = lib.licenses.mit;
    mainProgram = "OpenCode";
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
