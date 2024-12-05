{
  lib,
  python3Packages,
  fetchFromGitHub,

  # nativeBuildInputs
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,

  # buildInputs
  gdk-pixbuf,
  gtk4,
  libadwaita,
  vulkan-tools,

  # wrapper
  python3,
  clinfo,
  lsb-release,
  mesa-demos,
  vdpauinfo,

  # passthru
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gpu-viewer";
  version = "3.10";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "arunsivaramanneo";
    repo = "gpu-viewer";
    rev = "refs/tags/v${version}";
    hash = "sha256-0rbg3T9OXnSZ5+2cjgfNitAv1LgdO0N90wWJifzHcsg=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libadwaita
    vulkan-tools
  ];

  pythonPath = with python3Packages; [
    click
    pygobject3
  ];

  # Prevent double wrapping
  dontWrapGApps = true;

  postFixup = ''
    makeWrapper ${python3.interpreter} $out/bin/gpu-viewer \
      --prefix PATH : "${
        lib.makeBinPath [
          clinfo
          lsb-release
          mesa-demos
          vdpauinfo
          vulkan-tools
        ]
      }" \
      --add-flags "$out/share/gpu-viewer/Files/GPUViewer.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --chdir "$out/share/gpu-viewer/Files" \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/arunsivaramanneo/GPU-Viewer";
    description = "Front-end to glxinfo, vulkaninfo, clinfo and es2_info";
    changelog = "https://github.com/arunsivaramanneo/GPU-Viewer/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ GaetanLepage ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "gpu-viewer";
  };
}
