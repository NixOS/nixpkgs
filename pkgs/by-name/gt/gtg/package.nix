{
  lib,
  fetchFromGitHub,
  fetchpatch,
  meson,
  python3Packages,
  ninja,
  gtk3,
  wrapGAppsHook3,
  glib,
  gtksourceview4,
  itstool,
  gettext,
  pango,
  gdk-pixbuf,
  libsecret,
  gobject-introspection,
  xvfb-run,
}:

python3Packages.buildPythonApplication rec {
  pname = "gtg";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "gtg";
    rev = "v${version}";
    sha256 = "sha256-O8qBD92P2g8QrBdMXa6j0Ozk+W80Ny5yk0KNTy7ekfE=";
  };

  patches = [
    (fetchpatch {
      name = "replace-imp-with-importlib.patch";
      url = "https://github.com/getting-things-gnome/gtg/commit/568a00a3296d12cf3b2846c59bc99d13ecba7d47.patch";
      hash = "sha256-i3F638ZGiKfSxVUZm6rzzPRpcIHLOO9dgV0SzNLSroI=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    itstool
    gettext
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview4
    pango
    gdk-pixbuf
    libsecret
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
    lxml
    gst-python
    liblarch
    caldav
    vobject
  ];

  nativeCheckInputs = with python3Packages; [
    mock
    xvfb-run
    pytest
  ];

  preBuild = ''
    export HOME="$TMP"
  '';

  format = "other";

  checkPhase = "xvfb-run pytest ../tests/";

  meta = with lib; {
    description = "Personal tasks and TODO-list items organizer";
    mainProgram = "gtg";
    longDescription = ''
      "Getting Things GNOME" (GTG) is a personal tasks and ToDo list organizer inspired by the "Getting Things Done" (GTD) methodology.
      GTG is intended to help you track everything you need to do and need to know, from small tasks to large projects.
    '';
    homepage = "https://github.com/getting-things-gnome/gtg";
    downloadPage = "https://github.com/getting-things-gnome/gtg/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ oyren ];
    platforms = platforms.linux;
  };
}
