{ lib
, python3Packages
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
}:

python3Packages.buildPythonApplication rec {
  pname = "mousam";
  version = "1.3.1";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "amit9838";
    repo = "mousam";
    rev = "refs/tags/v${version}";
    hash = "sha256-QFEn7o3DRJyRLbEfb86AsS/ifYqzs3b5n2fZa/9Mm1A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Beautiful and lightweight weather app based on Python and GTK4";
    homepage = "https://amit9838.github.io/mousam";
    license = with licenses; [ gpl3Plus ];
    mainProgram = "mousam";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
