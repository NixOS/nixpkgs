{
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gobject-introspection,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "lenspect";
  version = "1.0.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "vmkspv";
    repo = "lenspect";
    tag = "v${version}";
    hash = "sha256-p0QVQK4uengvqq/iyanqN9WT/zkgyL/q/gV4K91VA48=";
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
    libadwaita
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
    changelog = "https://github.com/vmkspv/lenspect/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "lenspect";
    platforms = lib.platforms.linux;
  };
}
