{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, autoAddDriverRunpath
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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "nokyan";
    repo = "resources";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SHawaH09+mDovFiznZ+ZkUgUbv5tQGcXBgUGrdetOcA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "resources-${finalAttrs.version}";
    hash = "sha256-zqCqbQAUAIhjntX4gcV1aoJwjozZFlF7Sr49w7uIgaI=";
  };

  nativeBuildInputs = [
    appstream-glib
    autoAddDriverRunpath
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
    changelog = "https://github.com/nokyan/resources/releases/tag/v${finalAttrs.version}";
    description = "Monitor your system resources and processes";
    homepage = "https://github.com/nokyan/resources";
    license = lib.licenses.gpl3Only;
    mainProgram = "resources";
    maintainers = with lib.maintainers; [ lukas-heiligenbrunner ewuuwe ] ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
})
