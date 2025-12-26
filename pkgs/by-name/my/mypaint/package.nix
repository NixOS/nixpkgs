{
  lib,
  fetchFromGitHub,
  fetchpatch,
  gtk3,
  gettext,
  json_c,
  lcms2,
  libpng,
  librsvg,
  gobject-introspection,
  libmypaint,
  hicolor-icon-theme,
  mypaint-brushes,
  gdk-pixbuf,
  pkg-config,
  python3,
  swig,
  wrapGAppsHook3,
}:

let
  inherit (python3.pkgs)
    pycairo
    pygobject3
    numpy
    buildPythonApplication
    ;
in
buildPythonApplication rec {
  pname = "mypaint";
  version = "2.0.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint";
    tag = "v${version}";
    hash = "sha256-rVKcxzWZRLcuxK8xRyRgvitXAh4uOEyqHswLeTdA2Mk=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build due to setuptools issue.
    # https://github.com/mypaint/mypaint/pull/1183
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/423950bec96d6057eac70442de577364d784a847.patch";
      hash = "sha256-OxJJOi20bFMRibL59zx6svtMrkgeMYyEvbdSXbZHqpc=";
    })
    # https://github.com/mypaint/mypaint/pull/1193
    (fetchpatch {
      name = "python-3.11-compatibility.patch";
      url = "https://github.com/mypaint/mypaint/commit/032a155b72f2b021f66a994050d83f07342d04af.patch";
      hash = "sha256-EI4WJbpZrCtFMKd6QdXlWpRpIHi37gJffDjclzTLaLc=";
    })
    # Fix drag-n-drop file opening
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/66b2ba98bd953afa73d0d6ac71040b14a4ea266b.patch";
      hash = "sha256-4AWXD/JMpNA5otl2ad1ZLVPW49pycuOXGcgfzvj0XEE=";
    })
    # Fix crash with locked layer
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/0b720f8867f18acccc8e6ec770a9cc494aa81dcf.patch";
      hash = "sha256-ahYeERiMLA8yKIXQota6/ApAbOW0XwsHO2JkEEMm1Ow=";
    })
    # Refactoring for the following patch to apply.
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/d7d2496401a112a178d5fa2e491f0cc7537d24cd.patch";
      hash = "sha256-dIW6qWqY96+bsUDQQtGtjENvypnh//Ep3xW+wooCJ14=";
      includes = [
        "gui/colors/hcywheel.py"
      ];
    })
    # Fix crash with hcy wheel masking
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/5496b1cd1113fcd46230d87760b7e6b51cc747bc.patch";
      hash = "sha256-h+sE1LW04xDU2rofH5KqXsY1M0jacfBNBC+Zb0i6y1w=";
    })
    # Format source so the later patches apply
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/69d1d553034a31c0a466050a4acb323787dd04e6.patch";
      hash = "sha256-nziaPgfZRzPUvQEyQUM4FQbasHLFFT88H8qucbYI0pA=";
      includes = [
        "lib/strokemap.py"
        "lib/stroke.py"
      ];
    })
    # Fix numpy deprecation
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/2a92b6baf452aba2cff3cc0a7782b301da3933d7.patch";
      hash = "sha256-IkzdrA3pmeiihDOMzqIfc3uDd/wO3cI6dT+cVVhaQcI=";
    })
    # Fix numpy deprecation
    (fetchpatch {
      url = "https://github.com/mypaint/mypaint/commit/ab017e073e83a4930a0fb09608682bf4b7ab1874.patch";
      hash = "sha256-7OFqH75/gJYRJ1vROUDIkUqoBowAolBYQ5anWtp228o=";
    })
  ];

  nativeBuildInputs = [
    gettext
    pkg-config
    swig
    wrapGAppsHook3
    gobject-introspection # for setup hook
    hicolor-icon-theme # fór setup hook
    python3.pkgs.setuptools
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    libmypaint
    mypaint-brushes
    json_c
    lcms2
    libpng
    librsvg
    pycairo
    pygobject3

    # Mypaint checks for a presence of this theme scaffold and crashes when not present.
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [
    numpy
    pycairo
    pygobject3
  ];

  nativeCheckInputs = [
    gtk3
  ];

  buildPhase = ''
    runHook preBuild

    ${python3.interpreter} setup.py build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python3.interpreter} setup.py managed_install --prefix=$out

    runHook postInstall
  '';

  # tests require unmaintained and removed nose, it should switch to pytest
  # https://github.com/mypaint/mypaint/issues/1191
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    HOME=$TEMPDIR ${python3.interpreter} setup.py test

    runHook postCheck
  '';

  meta = {
    description = "Graphics application for digital painters";
    homepage = "http://mypaint.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
