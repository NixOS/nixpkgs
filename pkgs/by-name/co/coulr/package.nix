{
  lib,
  fetchFromGitHub,
  python3,
  wrapGAppsHook4,
  pkg-config,
  meson,
  ninja,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  libportal-gtk4,
  libnotify,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "coulr";
  version = "2.1.0";

  pyproject = false;
  dontWrapGApps = true;

  src = fetchFromGitHub {
    owner = "Huluti";
    repo = "Coulr";
    rev = version;
    hash = "sha256-1xnL5AWl/rLQu3i9m6uxbS4QT+690hmEW8kYTwkg7Gw=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    appstream-glib
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libportal-gtk4
    libnotify
  ];

  dependencies = [ python3.pkgs.pygobject3 ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace build-aux/meson/postinstall.py \
      --replace-fail gtk-update-icon-cache gtk4-update-icon-cache
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Color box to help developers and designers";
    homepage = "https://github.com/Huluti/Coulr";
    changelog = "https://github.com/Huluti/Coulr/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "coulr";
    platforms = lib.platforms.linux;
  };
}
