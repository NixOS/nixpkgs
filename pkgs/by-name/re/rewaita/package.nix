{
  lib,
  python3Packages,
  fetchFromGitHub,
  ninja,
  meson,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  libadwaita,
  libportal,
  nix-update-script,
}:
let
  version = "1.0.4";
in
python3Packages.buildPythonApplication {
  pname = "rewaita";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "SwordPuffin";
    repo = "Rewaita";
    tag = "v${version}";
    hash = "sha256-dN9jO9maTnlW38/cvRBUZpB6oZMX5n33ZTiKrB1eKEw=";
  };

  patches = [ ./fix-copy-tree.patch ];

  postPatch = ''
    substituteInPlace src/window.py \
      --replace-fail 'shutil.copy(' 'shutil.copyfile('

    substituteInPlace src/{custom_theme,interface_to_shell_theme,utils}.py \
      --replace-fail 'shutil.copy2' 'shutil.copyfile'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
    gtk4
    desktop-file-utils
    appstream-glib
    blueprint-compiler
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  buildInputs = [
    libadwaita
    gtk4
    libportal
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bring color to Adwaita";
    homepage = "https://github.com/SwordPuffin/Rewaita";
    changelog = "https://github.com/SwordPuffin/Rewaita/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rewaita";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      awwpotato
      getchoo
    ];
  };
}
