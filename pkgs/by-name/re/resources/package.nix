{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, glib
, gtk4
, libadwaita
, dmidecode
, util-linux
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resources";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nokyan";
    repo = "resources";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-RYpPg9dEasHkXF2eHpeCze5j0FC1+9/J0e2lRw8AdKc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "resources-${finalAttrs.version}";
    hash = "sha256-zliLpmunlxRsWv9N8AswVoRqcNy5PuI5NzNjaXyTiGk=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  postPatch = ''
    substituteInPlace src/utils/memory.rs \
      --replace '"dmidecode"' '"${dmidecode}/bin/dmidecode"'
    substituteInPlace src/utils/cpu.rs \
      --replace '"lscpu"' '"${util-linux}/bin/lscpu"'
    substituteInPlace src/utils/memory.rs \
      --replace '"pkexec"' '"/run/wrappers/bin/pkexec"'
  '';

  mesonFlags = [
    (lib.mesonOption "profile" "default")
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/nokyan/resources/releases/tag/${finalAttrs.version}";
    description = "Monitor your system resources and processes";
    homepage = "https://github.com/nokyan/resources";
    license = lib.licenses.gpl3Only;
    mainProgram = "resources";
    maintainers = with lib.maintainers; [ lukas-heiligenbrunner ewuuwe ];
    platforms = lib.platforms.linux;
  };
})
