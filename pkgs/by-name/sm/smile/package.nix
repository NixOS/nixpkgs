{ lib
, python3
, fetchFromGitHub
, desktop-file-utils
, glib
, gobject-introspection
, meson
, ninja
, wrapGAppsHook4
, libadwaita
, xdotool
, wl-clipboard
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smile";
  version = "2.9.5";
  pyproject = false; # Builds with meson

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = "smile";
    rev = version;
    hash = "sha256-WwkwJXRnIvBS0cdcmJhErZLe0wwvarUdE7rpx7qcd2E=";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    glib # for glib-compile-resources
    gobject-introspection
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3.pkgs; [
    dbus-python
    manimpango
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [
        xdotool
        wl-clipboard
      ]}
    )
  '';

  meta = {
    changelog = "https://smile.mijorus.it/changelog";
    description = "Emoji picker for linux, with custom tags support and localization";
    downloadPage = "https://github.com/mijorus/smile";
    homepage = "https://mijorus.it/projects/smile/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "smile";
    maintainers = with lib.maintainers; [ koppor aleksana ];
  };
}
