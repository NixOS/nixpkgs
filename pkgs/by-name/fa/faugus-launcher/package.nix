{
  fetchFromGitHub,
  gobject-introspection,
  icoextract,
  lib,
  lsfg-vk,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  umu-launcher,
  wrapGAppsHook4,
  xdg-utils,
  gtk4,
  libadwaita,
  libmanette,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "faugus-launcher";
  version = "2.0.2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = finalAttrs.version;
    hash = "sha256-0knobTbMLOkRIGze+gHaee2Duq4ClMapTCzICX35A8s=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libmanette
  ];

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

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --suffix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"
      --suffix PATH : "${
        lib.makeBinPath [
          icoextract
          umu-launcher
          xdg-utils
        ]
      }"
    )
    wrapProgram $out/bin/faugus-launcher ''${makeWrapperArgs[@]}
  '';

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
