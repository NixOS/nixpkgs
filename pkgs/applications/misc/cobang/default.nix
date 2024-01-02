{ lib
, atk
, buildPythonApplication
, fetchFromGitHub
, gdk-pixbuf
, gobject-introspection
, gst-plugins-good
, gst-python
, gtk3
, kiss-headers
, libhandy
, librsvg
, logbook
, networkmanager
, pango
, pillow
, poetry-core
, pygobject3
, pytestCheckHook
, python
, python-zbar
, pythonRelaxDepsHook
, requests
, single-version
, wrapGAppsHook
}:

buildPythonApplication rec {
  pname = "cobang";
  version = "0.10.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = "CoBang";
    rev = "refs/tags/v${version}";
    hash = "sha256-yNDnBTBmwcP3g51UkkLNyF4eHYjblwxPxS2lMwbFKUM=";
  };

  pythonRelaxDeps = [
    "logbook"
    "Pillow"
  ];

  nativeBuildInputs = [
    gobject-introspection
    pythonRelaxDepsHook
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    gdk-pixbuf
    gst-plugins-good
    libhandy
    networkmanager
    pango
  ];

  propagatedBuildInputs = [
    gst-python
    kiss-headers
    logbook
    pillow
    poetry-core
    pygobject3
    python-zbar
    requests
    single-version
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
    install -Dm 644 $out/${python.sitePackages}/data/vn.hoabinh.quan.CoBang.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/vn.hoabinh.quan.CoBang.desktop \
      --replace "Exec=" "Exec=$out/bin/"
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
    platforms = [ "x86_64-linux" ];
  };
}
