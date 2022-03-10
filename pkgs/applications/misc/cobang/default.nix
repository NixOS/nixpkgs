{ lib
, buildPythonApplication
, fetchFromGitHub
, wrapGAppsHook
, atk
, gdk-pixbuf
, gobject-introspection
, gtk3
, gst-plugins-good
, libhandy
, librsvg
, networkmanager
, pango
, gst-python
, kiss-headers
, Logbook
, pillow
, poetry-core
, pygobject3
, python
, python-zbar
, requests
, single-version
, pytestCheckHook }:

buildPythonApplication rec {
  pname = "cobang";
  version = "0.9.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = "CoBang";
    rev = "v${version}";
    sha256 = "sha256-YcXQ2wAgFSsJEqcaDQotpX1put4pQaF511kwq/c2yHw=";
  };

  patches = [
    ./0001-Poetry-core-and-pillow-9.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    gst-python
    kiss-headers
    Logbook
    pillow
    poetry-core
    pygobject3
    python-zbar
    requests
    single-version
  ];

  buildInputs = [
    atk
    gdk-pixbuf
    # Needed to detect namespaces
    gobject-introspection
    gst-plugins-good
    libhandy
    networkmanager
    pango
  ];

  checkInputs = [
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
