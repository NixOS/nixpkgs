{ lib
, fetchFromGitHub
, pkg-config
, meson
, ninja
, gtk4
, libadwaita
, python3Packages
, gobject-introspection
, vulkan-tools
, python3
, wrapGAppsHook4
, gdk-pixbuf
, lsb-release
, mesa-demos
, vdpauinfo
, clinfo
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gpu-viewer";
  version = "3.04";

  format = "other";

  src = fetchFromGitHub {
    owner = "arunsivaramanneo";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+FDBHSVBTUHnhu2n7i9W1zIZe2wjY+OuFwQOJZojuzs=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    vulkan-tools
    gdk-pixbuf
  ];

  pythonPath = with python3Packages; [
    pygobject3
    click
  ];

  # Prevent double wrapping
  dontWrapGApps = true;

  postFixup = ''
    makeWrapper ${python3.interpreter} $out/bin/gpu-viewer \
      --prefix PATH : "${lib.makeBinPath [ clinfo lsb-release mesa-demos vdpauinfo vulkan-tools ]}" \
      --add-flags "$out/share/gpu-viewer/Files/GPUViewer.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --chdir "$out/share/gpu-viewer/Files" \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';


  meta = with lib; {
    homepage = "https://github.com/arunsivaramanneo/GPU-Viewer";
    description = "Front-end to glxinfo, vulkaninfo, clinfo and es2_info";
    changelog = "https://github.com/arunsivaramanneo/GPU-Viewer/releases/tag/v${version}";
    maintainers = with maintainers; [ GaetanLepage ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "gpu-viewer";
  };
}
