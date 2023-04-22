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
, wrapGAppsHook
, gdk-pixbuf
, lsb-release
, glxinfo
, vdpauinfo
, clinfo
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gpu-viewer";
  version = "2.26";

  format = "other";

  src = fetchFromGitHub {
    owner = "arunsivaramanneo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3GYJq76g/pU8dt+OMGBeDcw47z5Xv3AGkLsACcBCELs=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
    wrapGAppsHook
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
      --prefix PATH : "${lib.makeBinPath [ clinfo glxinfo lsb-release vdpauinfo vulkan-tools ]}" \
      --add-flags "$out/share/gpu-viewer/Files/GPUViewer.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --chdir "$out/share/gpu-viewer/Files" \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';


  meta = with lib; {
    homepage = "https://github.com/arunsivaramanneo/GPU-Viewer";
    description = "A front-end to glxinfo, vulkaninfo, clinfo and es2_info";
    maintainers = with maintainers; [ GaetanLepage ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
