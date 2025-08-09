{
  lib,
  python3Packages,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gst_all_1,
  gobject-introspection,
  libadwaita,
  libportal-gtk4,
  meson,
  networkmanager,
  ninja,
  pipewire,
  pkg-config,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "cobang";
  version = "1.7.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = "CoBang";
    tag = "v${version}";
    hash = "sha256-rBGz9g6+6jguJggBQKlyOWoME3VHOP8Gq4VtYywoVdI=";
  };

  # https://github.com/hongquan/CoBang/issues/117
  postPatch = ''
    substituteInPlace src/window.blp \
      --replace-fail 'seeing-symbolic' 'scanner-symbolic'
  '';

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    # Needed to recognize gobject namespaces
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    # Requires v4l2src
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    # gtk4paintablesink
    gst_all_1.gst-plugins-rs
    libadwaita
    libportal-gtk4
    networkmanager
    pipewire
  ];

  dependencies = with python3Packages; [
    logbook
    # Needed as a gobject namespace and to fix 'Caps' object is not subscriptable
    gst-python
    pillow
    pygobject3
    python-zbar
  ];

  # Wrapping this manually for SVG recognition
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "QR code scanner desktop app for Linux";
    homepage = "https://github.com/hongquan/CoBang";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      aleksana
      dvaerum
    ];
    mainProgram = "cobang";
    platforms = lib.platforms.linux;
  };
}
