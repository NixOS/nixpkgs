{
  lib,
  gtk4,
  glib,
  gobject-introspection,
  efibootmgr,
  python3,
  util-linux,
  wrapGAppsHook3,
  desktop-file-utils,
  hicolor-icon-theme,
  meson,
  ninja,
  pkg-config,
  gettext,
  appstream,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efiboots";
  version = "2.1.0-unstable-2025-06-03";

  src = fetchFromGitHub {
    owner = "Elinvention";
    repo = "efiboots";
    rev = "3d40c87e7a3711c3b96289ea680e9fa729980051";
    hash = "sha256-IKFfLsbYd7KDnzEo04Sh39j5qTMYgsRAS5JdbbPPPmA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    appstream
    wrapGAppsHook3
    python3.pkgs.wrapPython
    desktop-file-utils # needed for update-desktop-database
    glib # needed for glib-compile-schemas
    gobject-introspection # need for gtk namespace to be available
    hicolor-icon-theme # needed for postinstall script
  ];

  buildInputs = [
    gtk4
    glib
  ];

  propagatedBuildInputs = [ python3.pkgs.pygobject3 ];

  doCheck = true;
  checkInputs = finalAttrs.buildInputs;

  # ModuleNotFoundError: No module named 'gi' error
  # fix found from https://github.com/NixOS/nixpkgs/issues/343134#issuecomment-2453502399
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=( \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : "${
        lib.makeBinPath [
          efibootmgr
          util-linux
        ]
      }" \
    )
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "Manage EFI boot loader entries with this simple GUI";
    homepage = "https://github.com/Elinvention/efiboots";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "efiboots";
    maintainers = with lib.maintainers; [
      Elinvention
      phanirithvij
    ];
  };
})
