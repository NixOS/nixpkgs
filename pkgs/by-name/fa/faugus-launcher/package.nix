{
  coreutils,
  fetchFromGitHub,
  gamemode,
  gawk,
  gnugrep,
  gobject-introspection,
  gst_all_1,
  icoextract,
  lib,
  libadwaita,
  libgudev,
  libmanette,
  lsfg-vk,
  lsfgSupport ? false,
  withGameMode ? true,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  pciutils,
  umu-launcher,
  wrapGAppsHook4,
  xdg-utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "faugus-launcher";
  version = "2.5.7";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = finalAttrs.version;
    hash = "sha256-lB7/X7ilnoIc27Ggr+xCL/B0Gb9fTHWJNE9ajfYPccI=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libmanette
    libgudev
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  dependencies = with python3Packages; [
    dbus-python
    pefile
    pillow
    psutil
    pygobject3
    requests
    vdf
  ];

  postPatch = ''
    substituteInPlace faugus-launcher \
      --replace-fail "/usr/bin/python3" "${python3Packages.python.interpreter}"

    substituteInPlace faugus/path_manager.py \
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'"
  ''
  + lib.optionalString lsfgSupport ''
    substituteInPlace faugus/path_manager.py \
      --replace-fail "/usr/lib/liblsfg-vk-layer.so" "${lib.getLib lsfg-vk}/lib/liblsfg-vk-layer.so"
  '';

  dontWrapGApps = true;

  postFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      ${lib.optionalString withGameMode ''
        --prefix LD_PRELOAD : libgamemode.so
        --prefix LD_LIBRARY_PATH : "${lib.getLib gamemode}/lib"
      ''}
      --suffix PATH : "${
        lib.makeBinPath (
          [
            coreutils
            gawk
            gnugrep
            icoextract
            pciutils
            umu-launcher
            xdg-utils
          ]
          ++ lib.optional withGameMode gamemode
        )
      }"
    )
    wrapGApp $out/bin/faugus-launcher
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "faugus" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and lightweight app for running Windows games using UMU-Launcher";
    homepage = "https://github.com/Faugus/faugus-launcher";
    changelog = "https://github.com/Faugus/faugus-launcher/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "faugus-launcher";
    platforms = lib.platforms.linux;
  };
})
