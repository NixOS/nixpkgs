{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  gettext,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  jpegoptim,
  libwebp,
  optipng,
  pngquant,
  oxipng,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "curtail";
  version = "1.14.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Huluti";
    repo = "Curtail";
    tag = finalAttrs.version;
    sha256 = "sha256-AxQe7abHZp4SRp90fkFbmXf3ZQH3VmxQVkpxRcit+54=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gettext
    gtk4
    libadwaita
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    appstream-glib
    gettext
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
  ];

  preInstall = ''
    patchShebangs ../build-aux/meson/postinstall.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${
        lib.makeBinPath [
          jpegoptim
          libwebp
          optipng
          pngquant
          oxipng
        ]
      }"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple & useful image compressor";
    mainProgram = "curtail";
    homepage = "https://github.com/Huluti/Curtail";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.gnome-circle ];
  };
})
