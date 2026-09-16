{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  python3,
  wrapGAppsHook4,
  libadwaita,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "netsleuth";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "vmkspv";
    repo = "netsleuth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wlD2hWC3mlgfJc+Ro3TuPBnRRrn+Cc/nyzFWfc2TDaA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    appstream
    blueprint-compiler
    desktop-file-utils
    (python3.withPackages (ps: [ ps.pygobject3 ]))
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Simple utility for the calculation and analysis of IP subnet values";
    homepage = "https://github.com/vmkspv/netsleuth";
    changelog = "https://github.com/vmkspv/netsleuth/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "netsleuth";
    platforms = lib.platforms.linux;
  };
})
