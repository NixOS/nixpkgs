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
  libportal-gtk4,
  gtksourceview5,
  nix-update-script,
}:
let
  version = "1.1.1";
in
python3Packages.buildPythonApplication {
  pname = "rewaita";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "SwordPuffin";
    repo = "Rewaita";
    tag = "v${version}";
    hash = "sha256-T9GQuhMkCEUFX2BpTTQ+zKhDpSxtVKuncITtm7nqzyY=";
  };

  postPatch = ''
    substituteInPlace src/window.py \
      --replace-fail 'shutil.copy(' 'shutil.copyfile('
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
    pillow
    numpy
    fortune
  ];

  buildInputs = [
    libadwaita
    gtk4
    libportal-gtk4
    gtksourceview5
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
      da157
      getchoo
    ];
  };
}
