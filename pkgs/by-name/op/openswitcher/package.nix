{
  lib,
  python3Packages,
  fetchFromSourcehut,
  desktop-file-utils,
  gobject-introspection,
  gtk3,
  libhandy,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wrapGAppsHook3,
  udevCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "openswitcher";
  version = "0.13.0";
  format = "other";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "pyatem";
    rev = version;
    hash = "sha256-eEn09e+ZED4DGEWTUou9CRgazngHIXZv51CLhX9YuBI=";
  };

  outputs = [
    "out"
    "man"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    gtk3
    meson
    ninja
    pkg-config
    scdoc
    wrapGAppsHook3
    udevCheckHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    gtk3
    libhandy
  ];

  propagatedBuildInputs = with python3Packages; [
    # for switcher-control, bmd-setup
    paho-mqtt
    pyatem
    pygobject3
    # for atemswitch
    requests
    # for openswitcher-proxy
    toml
  ];

  postInstall = ''
    install -Dm644 -t $out/lib/udev/rules.d/ $src/100-blackmagicdesign.rules
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Blackmagic Design mixer control application";
    downloadPage = "https://git.sr.ht/~martijnbraam/pyatem";
    homepage = "https://openswitcher.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "switcher-control";
  };
}
