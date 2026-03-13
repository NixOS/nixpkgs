{
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  glib-networking,
  gobject-introspection,
  lib,
  libadwaita,
  libsecret,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lenspect";
  version = "1.0.4";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "vmkspv";
    repo = "lenspect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zYIDTFjT9izc4WFjs9fYDPDrQ8z16i2Bko5JW0tgCBk=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    libadwaita
    libsecret
    libsoup_3
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight security threat scanner intended to make malware detection more accessible and efficient";
    homepage = "https://github.com/vmkspv/lenspect";
    changelog = "https://github.com/vmkspv/lenspect/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "lenspect";
    platforms = lib.platforms.linux;
  };
})
