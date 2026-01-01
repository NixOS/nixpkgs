{
  lib,
  fetchurl,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  mcomix,
<<<<<<< HEAD
  python3,
=======
  python312, # TODO: Revert to python3 when upgrading past 3.1.0
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  testers,
  wrapGAppsHook3,

  # Recommended Dependencies:
  p7zip,
  unrar,
  chardetSupport ? true,
  pdfSupport ? true,
  unrarSupport ? false, # unfree software
}:

<<<<<<< HEAD
python3.pkgs.buildPythonApplication rec {
  pname = "mcomix";
  version = "3.1.1";
=======
python312.pkgs.buildPythonApplication rec {
  pname = "mcomix";
  version = "3.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchurl {
    url = "mirror://sourceforge/mcomix/mcomix-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-oQqq7XvAfet0796Tv5qKJ+G8vxgkoFGbJkz+5YK+zvg=";
=======
    hash = "sha256-+Shuun/7w86VKBNamTmCPEJfO76fdKY5+HBvzCi0xCc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    gtk3
    gdk-pixbuf
  ];

  nativeBuildInputs = [
    gobject-introspection
<<<<<<< HEAD
    python3.pkgs.setuptools
=======
    python312.pkgs.setuptools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    wrapGAppsHook3
  ];

  propagatedBuildInputs =
<<<<<<< HEAD
    with python3.pkgs;
=======
    with python312.pkgs;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Comic book reader and image viewer";
    mainProgram = "mcomix";
    longDescription = ''
      User-friendly, customizable image viewer, specifically designed to handle
      comic books and manga supporting a variety of container formats
      (including CBR, CBZ, CB7, CBT, LHA and PDF)
    '';
    homepage = "https://sourceforge.net/projects/mcomix/";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      confus
      thiagokokada
    ];
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thiagokokada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
