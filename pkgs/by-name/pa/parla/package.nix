{
  deltachat-rpc-server,
  fetchFromGitHub,
  glib,
  gtk4,
  json-glib,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  vala,
  gst_all_1,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parla";
  version = "0.9.8";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "trufae";
    repo = "parla";
    tag = finalAttrs.version;
    hash = "sha256-7A77iywQfi+C1s6gZhrYPyHykUSOEd/bDGHjDT+vEvA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  mesonFlags = [
    "-Drpc_server_path=${lib.getExe deltachat-rpc-server}"
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
    webkitgtk_6_0
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/trufae/parla/releases/tag/${finalAttrs.src.tag}";
    description = "Native Gnome DeltaChat client";
    homepage = "https://github.com/trufae/parla";
    license = lib.licenses.gpl3Only;
    mainProgram = "parla";
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
})
