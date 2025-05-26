{
  lib,
  fetchurl,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  mcomix,
  python3,
  testers,
  wrapGAppsHook3,

  # Recommended Dependencies:
  p7zip,
  unrar,
  chardetSupport ? true,
  pdfSupport ? true,
  unrarSupport ? false, # unfree software
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcomix";
  version = "3.1.0";
  pyproject = true;

  src = fetchurl {
    url = "mirror://sourceforge/mcomix/mcomix-${version}.tar.gz";
    hash = "sha256-+Shuun/7w86VKBNamTmCPEJfO76fdKY5+HBvzCi0xCc=";
  };

  buildInputs = [
    gtk3
    gdk-pixbuf
  ];

  nativeBuildInputs = [
    gobject-introspection
    python3.pkgs.setuptools
    wrapGAppsHook3
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      pillow
      pycairo
      pygobject3
    ]
    ++ lib.optionals chardetSupport [ chardet ]
    ++ lib.optionals pdfSupport [ pymupdf ];

  # No tests included in .tar.gz
  doCheck = false;

  # Prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${lib.makeBinPath ([ p7zip ] ++ lib.optional unrarSupport unrar)}"
    )
  '';

  postInstall = ''
    cp -a share $out/
  '';

  passthru.tests.version = testers.testVersion {
    package = mcomix;
  };

  meta = with lib; {
    description = "Comic book reader and image viewer";
    mainProgram = "mcomix";
    longDescription = ''
      User-friendly, customizable image viewer, specifically designed to handle
      comic books and manga supporting a variety of container formats
      (including CBR, CBZ, CB7, CBT, LHA and PDF)
    '';
    homepage = "https://sourceforge.net/projects/mcomix/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
