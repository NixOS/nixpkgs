{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  file,
  procps,
  _7zz,
  which,
  appimage-run,
  gtk4,
  bintools,
  libnotify,
  dwarfs,
  squashfs-tools,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gearlever";
  version = "4.6.2";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = "gearlever";
    tag = finalAttrs.version;
    hash = "sha256-OeQd7ksozppCHlREWn546TjHsgz2H/Azd65E1FtS9ZE=";
  };

  postPatch =
    # https://github.com/NixOS/nixpkgs/issues/302605
    # But since the author only builds on flatpak, we don't expect much on it...
    ''
      substituteInPlace build-aux/meson/postinstall.py \
        --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
    ''
    # Use gtk4 instead of gtk3 to get smaller closure size
    + ''
      substituteInPlace src/providers/AppImageProvider.py \
        --replace-fail "gtk-launch" "gtk4-launch"
    '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [
    pygobject3
    dbus-python
    pyxdg
    requests
    ftputil
    desktop-entry-lib
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      file
      procps # ps
      _7zz # 7zz
      which
      appimage-run
      desktop-file-utils # update-desktop-database
      gtk4.dev # gtk4-launch
      bintools # readelf
      libnotify # notify-send
      dwarfs # dwarfsextract, dwarfsck
      squashfs-tools # unsquashfs
    ])
  ];

  meta = {
    description = "Manage AppImages with ease";
    longDescription = ''
      Features:

      - Integrate AppImages into your app menu with just one click
      - Drag and drop files directly from your file manager
      - Keep all the AppImages organized in a custom folder
      - Open new AppImages directly with Gear lever
      - Manage updates: keep older versions installed or replace
        them with the latest release
      - Save CLI apps with their executable name automatically
      - Modern and Fresh UI
    '';
    homepage = "https://mijorus.it/projects/gearlever";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "gearlever";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
