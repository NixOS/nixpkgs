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
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  umu-launcher,
  wrapGAppsHook4,
  xdg-utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "faugus-launcher";
  version = "2.2.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = finalAttrs.version;
    hash = "sha256-NCWuyIhPVs+6zYpi4JYxukKyO+YLnHPOfd3APTECTFE=";
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
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'" \
      --replace-fail "/usr/lib/extensions/vulkan/lsfgvk/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so" \
      --replace-fail "/usr/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set PYTHONPATH "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"
      --set LD_PRELOAD "libgamemode.so:$LD_PRELOAD"
      --set LD_LIBRARY_PATH "${lib.getLib gamemode}/lib:$LD_LIBRARY_PATH"
      --suffix PATH : "${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          icoextract
          umu-launcher
          xdg-utils
        ]
      }"
    )
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
