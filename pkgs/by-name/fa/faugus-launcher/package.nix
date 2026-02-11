{
  fetchFromGitHub,
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
  lsfg-vk,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "faugus-launcher";
  version = "1.14.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = finalAttrs.version;
    hash = "sha256-1qVHis8Cm8v9+1UyVFyWrSBQsIK0qjEW6Bu61ZJfWbM=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    libayatana-appindicator
  ];

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
      --replace-fail "/usr/lib/extensions/vulkan/lsfgvk/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so" \
      --replace-fail 'Path("/usr/lib/liblsfg-vk.so")' 'Path("${lsfg-vk}/lib/liblsfg-vk.so")' \
      --replace-fail 'Exec={faugus_run}' 'Exec=faugus-run'

    substituteInPlace faugus_run.py \
      --replace-fail "PathManager.user_data('faugus-launcher/umu-run')" "'${lib.getExe umu-launcher}'"

    substituteInPlace faugus/shortcut.py \
      --replace-fail "/usr/lib/extensions/vulkan/lsfgvk/lib/liblsfg-vk.so" "${lsfg-vk}/lib/liblsfg-vk.so" \
      --replace-fail 'Path("/usr/lib/liblsfg-vk.so")' 'Path("${lsfg-vk}/lib/liblsfg-vk.so")'
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
    changelog = "https://github.com/Faugus/faugus-launcher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "faugus-launcher";
    platforms = lib.platforms.linux;
  };
})
