{
  lib,
  fetchFromGitHub,
  coreutils,
  gamemode,
  gawk,
  gnugrep,
  gobject-introspection,
  gst_all_1,
  icoextract,
  libadwaita,
  libgudev,
  libmanette,
  lsfg-vk,
  meson,
  ninja,
  nix-update-script,
  pciutils,
  python3Packages,
  umu-launcher,
  wrapGAppsHook4,
  xdg-utils,
  lsfgSupport ? false,
  withGameMode ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "faugus-launcher";
  version = "2.5.7";

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = finalAttrs.version;
    hash = "sha256-lB7/X7ilnoIc27Ggr+xCL/B0Gb9fTHWJNE9ajfYPccI=";
  };

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

  # has no tests
  doCheck = false;

  postFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      ${lib.optionalString withGameMode ''
        --prefix LD_PRELOAD : libgamemode.so
        --prefix LD_LIBRARY_PATH : "${lib.getLib gamemode}/lib"
      ''}
      --suffix PATH : ${lib.escapeShellArg (lib.makeBinPath finalAttrs.runtimeInputs)}
    )
    wrapGApp $out/bin/faugus-launcher
  '';

  dependencies = with python3Packages; [
    pefile
    pillow
    psutil
    pygobject3
    requests
    vdf
  ];

  dontWrapGApps = true;
  pyproject = false;
  pythonImportsCheck = [ "faugus" ];

  runtimeInputs = [
    coreutils
    gawk
    gnugrep
    icoextract
    pciutils
    umu-launcher
    xdg-utils
  ]
  ++ lib.optional withGameMode gamemode;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and lightweight app for running Windows games using UMU-Launcher";
    homepage = "https://github.com/Faugus/faugus-launcher";
    changelog = "https://github.com/Faugus/faugus-launcher/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      RoGreat
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "faugus-launcher";
  };
})
