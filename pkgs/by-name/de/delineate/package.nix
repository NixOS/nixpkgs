{
  appstream,
  buildNpmPackage,
  cargo,
  cmake,
  desktop-file-utils,
  fetchFromGitHub,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:
let
  d3-graphviz = buildNpmPackage rec {
    pname = "d3-graphviz";
    version = "5.6.0";

    src = fetchFromGitHub {
      owner = "magjac";
      repo = "d3-graphviz";
      tag = "v${version}";
      hash = "sha256-MZhAzR6+GIBTsLPJq5NqaEPHjiBMgYBJ0hFbDPNPgFk=";
    };

    npmDepsHash = "sha256-J1kptumP/8UoiYDM+AJOYUne0OSkMXCTAXW3ZmavU4E=";

    # keep the devDependencies, as Delineate imports d3 via node_modules
    # https://github.com/SeaDve/Delineate/blob/v0.1.0/data/graph_view/index.html#L10-L11
    npmPruneFlags = "--include=dev";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "delineate";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Delineate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFGh7clxc6UxQRTsNKrggWDvL3CPmzJmrvO1jqMVoTg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-RtQnpbjULtnvlc71L4KIKPES0WRSY2GoaIwt8UvlYOA=";
  };

  patches = [
    ./graphview-dir.patch
  ];

  nativeBuildInputs = [
    cargo
    cmake
    desktop-file-utils
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    gtksourceview5
    libadwaita
    webkitgtk_6_0
  ];

  dontUseCmakeConfigure = true;

  postInstall = ''
    ln -s ${d3-graphviz}/lib/node_modules/d3-graphviz $out/opt/delineate/graph_view/d3-graphviz
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "View and edit graphs";
    homepage = "https://github.com/SeaDve/Delineate";
    changelog = "https://github.com/SeaDve/Delineate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nekowinston ];
    platforms = lib.platforms.linux;
    mainProgram = "delineate";
  };
})
