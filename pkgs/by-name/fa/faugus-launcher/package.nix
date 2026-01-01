{
  fetchFromGitHub,
<<<<<<< HEAD
=======
  gamemode,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  gobject-introspection,
  icoextract,
  imagemagick,
  lib,
  libayatana-appindicator,
  libcanberra-gtk3,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  umu-launcher,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication rec {
  pname = "faugus-launcher";
<<<<<<< HEAD
  version = "1.11.8";
=======
  version = "1.10.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-VgafXX8EuX0WOpG0cxBNlUdLL4HrrcpdblpCMxka2ms=";
=======
    hash = "sha256-FmbAlvjzUEjKDFEI1O9TJGpKl8/WJaCYUVT75+oG2vc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    gobject-introspection
<<<<<<< HEAD
    meson
    ninja
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    wrapGAppsHook3
  ];

  buildInputs = [
    libayatana-appindicator
  ];

<<<<<<< HEAD
=======
  build-system = [
    meson
    ninja
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dependencies = with python3Packages; [
    filelock
    pillow
    psutil
    pygobject3
    requests
    vdf
  ];

  postPatch = ''
    substituteInPlace faugus_launcher.py \
      --replace-fail "PathManager.find_binary('faugus-run')" "'$out/bin/.faugus-run-wrapped'" \
      --replace-fail "PathManager.find_binary('faugus-proton-manager')" "'$out/bin/.faugus-proton-manager-wrapped'" \
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'" \
      --replace-fail 'Exec={faugus_run}' 'Exec=faugus-run'

    substituteInPlace faugus_run.py \
      --replace-fail "PathManager.find_binary('faugus-components')" "'$out/bin/.faugus-components-wrapped'" \
<<<<<<< HEAD
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'"
=======
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'" \
      --replace-fail "PathManager.find_library('libgamemode.so.0')" "'${lib.getLib gamemode}/lib/libgamemode.so.0'" \
      --replace-fail "PathManager.find_library('libgamemodeauto.so.0')" "'${lib.getLib gamemode}/lib/libgamemodeauto.so.0'"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --suffix PATH : "${
        lib.makeBinPath [
          icoextract
          imagemagick
          libcanberra-gtk3
          umu-launcher
          xdg-utils
        ]
      }"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and lightweight app for running Windows games using UMU-Launcher";
    homepage = "https://github.com/Faugus/faugus-launcher";
    changelog = "https://github.com/Faugus/faugus-launcher/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "faugus-launcher";
    platforms = lib.platforms.linux;
  };
}
