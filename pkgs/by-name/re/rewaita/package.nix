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
<<<<<<< HEAD
  libportal-gtk4,
  gtksourceview5,
  nix-update-script,
}:
let
  version = "1.1.0";
=======
  libportal,
  nix-update-script,
}:
let
  version = "1.0.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
python3Packages.buildPythonApplication {
  pname = "rewaita";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "SwordPuffin";
    repo = "Rewaita";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-B3CxtGKLvlGORae1b7vMDFbvNntVO24yrzbiHzOP28k=";
=======
    hash = "sha256-T1MrSg3DO6U/ztX4LYB1Uhpne+7xAfr8+INV5CyS0eE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    pillow
    numpy
    fortune
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    libadwaita
    gtk4
<<<<<<< HEAD
    libportal-gtk4
    gtksourceview5
=======
    libportal
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
