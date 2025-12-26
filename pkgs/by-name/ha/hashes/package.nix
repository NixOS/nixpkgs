{
  lib,
  fetchFromGitHub,
  nix-update-script,
  adwaita-icon-theme,
  gtk4,
  libadwaita,
  desktop-file-utils,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  cmake,
  python3Packages,
  appstream,
  gobject-introspection,
  glib,
}:

python3Packages.buildPythonApplication rec {
  pname = "hashes";
  version = "1.1.2";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = "hashes";
    tag = "v${version}";
    hash = "sha256-Nyf7jED6LnsFu86zWhRh05sdGKwVAybVsGLGFFsz6eA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    desktop-file-utils
    cmake
    pkg-config
    appstream
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    adwaita-icon-theme
  ];

  dependencies = with python3Packages; [
    name-that-hash
    pygobject3
  ];
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/zefr0x/hashes/tree/main";
    changelog = "https://github.com/zefr0x/hashes/releases/tag/v${version}";
    description = "Simple hash algorithm identification GUI";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "hashes";
    platforms = lib.platforms.unix;
  };
}
