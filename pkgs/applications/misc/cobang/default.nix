{ lib
, buildPythonApplication
, fetchFromGitHub
, brotlicffi
, gst-python
, kiss-headers
, logbook
, pillow
, pygobject3
, python-zbar
, requests
, single-version
, gobject-introspection
, gst-plugins-good
, gtk3
, libhandy
, librsvg
, networkmanager
, setuptools
, python
, pytestCheckHook
, wrapGAppsHook3
}:

buildPythonApplication rec {
  pname = "cobang";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = "CoBang";
    rev = "refs/tags/v${version}";
    hash = "sha256-4INScFnYSwVnGjaohgDL3Sv/NeIwiiyLux8c9/Y/Wq4=";
  };

  postPatch = ''
    # Fixes "Multiple top-level packages discovered in a flat-layout"
    sed -i '$ a\[tool.setuptools]' pyproject.toml
    sed -i '$ a\packages = ["cobang"]' pyproject.toml
  '';

  nativeBuildInputs = [
    # Needed to recognize gobject namespaces
    gobject-introspection
    wrapGAppsHook3
    setuptools
  ];

  buildInputs = [
    # Requires v4l2src
    gst-plugins-good
    # For gobject namespaces
    libhandy
    networkmanager
  ];

  propagatedBuildInputs = [
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Wrapping this manually for SVG recognition
  dontWrapGApps = true;

  postInstall = ''
    # Needed by the application
    cp -R data $out/${python.sitePackages}/

    # Icons and applications
    install -Dm 644 $out/${python.sitePackages}/data/vn.hoabinh.quan.CoBang.svg -t $out/share/pixmaps/
    install -Dm 644 $out/${python.sitePackages}/data/vn.hoabinh.quan.CoBang.desktop.in -t $out/share/applications/
    mv $out/${python.sitePackages}/data/vn.hoabinh.quan.CoBang.desktop{.in,}
  '';

  preFixup = ''
    wrapProgram $out/bin/cobang \
      ''${gappsWrapperArgs[@]} \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
  '';

  meta = with lib; {
    description = "A QR code scanner desktop app for Linux";
    homepage = "https://github.com/hongquan/CoBang";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "cobang";
    platforms = [ "x86_64-linux" ];
  };
}
