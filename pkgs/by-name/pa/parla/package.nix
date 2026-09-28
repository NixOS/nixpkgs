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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parla";
  version = "0.8.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "trufae";
    repo = "parla";
    tag = finalAttrs.version;
    hash = "sha256-BdmIbqYG5Ht4gH300j/BVPx+TKCxce/DippezOVa0m0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  mesonFlags = [
    "-Drpc_server_path=${lib.getExe deltachat-rpc-server}"
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
  ];

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
