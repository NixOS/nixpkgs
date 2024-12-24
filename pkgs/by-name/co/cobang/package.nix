{
  lib,
  python3Packages,
  fetchFromGitHub,
  gst_all_1,
  gobject-introspection,
  gtk3,
  libhandy,
  librsvg,
  networkmanager,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "cobang";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = "CoBang";
    rev = "refs/tags/v${version}";
    hash = "sha256-/8JtDoXFQGlM7tlwKd+WRIKpnKCD6OnMmbvElg7LbzU=";
  };

  postPatch = ''
    # Fixes "Multiple top-level packages discovered in a flat-layout"
    sed -i '$ a\[tool.setuptools]' pyproject.toml
    sed -i '$ a\packages = ["cobang"]' pyproject.toml
  '';

  nativeBuildInputs = with python3Packages; [
    # Needed to recognize gobject namespaces
    gobject-introspection
    wrapGAppsHook3
    setuptools
  ];

  buildInputs = with python3Packages; [
    # Requires v4l2src
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    # For gobject namespaces
    libhandy
    networkmanager
  ];

  dependencies = with python3Packages; [
    brotlicffi
    kiss-headers
    logbook
    pillow
    requests
    single-version
    # Unlisted dependencies
    pygobject3
    python-zbar
    # Needed as a gobject namespace and to fix 'Caps' object is not subscriptable
    gst-python
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "Pillow"
  ];

  # Wrapping this manually for SVG recognition
  dontWrapGApps = true;

  postInstall = ''
    # Needed by the application
    cp -R data $out/${python3Packages.python.sitePackages}/

    # Icons and applications
    install -Dm 644 $out/${python3Packages.python.sitePackages}/data/vn.hoabinh.quan.CoBang.svg -t $out/share/pixmaps/
    install -Dm 644 $out/${python3Packages.python.sitePackages}/data/vn.hoabinh.quan.CoBang.desktop.in -t $out/share/applications/
    mv $out/${python3Packages.python.sitePackages}/data/vn.hoabinh.quan.CoBang.desktop{.in,}
  '';

  preFixup = ''
    wrapProgram $out/bin/cobang \
      ''${gappsWrapperArgs[@]} \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
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
