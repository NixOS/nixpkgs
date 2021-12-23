{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, fetchpatch
, intltool
, gtk3
, gobject-introspection
, gst_all_1
, wrapGAppsHook
, xvfb-run
}:
python3Packages.buildPythonApplication rec {
  pname = "gourmand";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GourmandRecipeManager";
    repo = "gourmand";
    rev = version;
    sha256 = "sha256-QNcVfsAxcqtM7VGuoCQL7ZD26+PwxwFW3EkA7FAE0Z0=";
  };

  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  patches = [
    # Fix compatibility with Sqlalchemy 1.4, https://github.com/GourmandRecipeManager/gourmand/pull/80. This does not fix failing db tests.
    (fetchpatch {
      name = "fix-sqlalchemy-1.4-compat";
      url = "https://github.com/GourmandRecipeManager/gourmand/commit/533bd247a0fd6a08c527bc27d1a303487c6ad144.patch";
      sha256 = "sha256-C0joinwhy6pjmD2qlTm1wT7m4wXAvHbDMxw115kDDeU=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "beautifulsoup4==4.9.3" "beautifulsoup4" \
      --replace "lxml==4.6.3" "lxml" \
      --replace "pillow==8.2.0" "pillow" \
      --replace "pygobject==3.40.1" "pygobject" \
      --replace "requests==2.25.1"  "requests" \
      --replace "sqlalchemy==1.3.22" "sqlalchemy" \
      --replace "toml==0.10.2" "toml"
  '';

  nativeBuildInputs = [
    intltool
  ];

  buildInputs = [
    gtk3
    gobject-introspection
    gst_all_1.gstreamer
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    lxml
    pillow
    pygobject3
    requests
    sqlalchemy
    toml
    setuptools
    reportlab
    ebooklib
    pyenchant
    pygtkspellcheck
  ];

  checkInputs = [
    xvfb-run
  ] ++  (with python3Packages; [
    pytest
  ]);

  postInstall = ''
    install -D data/io.github.GourmandRecipeManager.Gourmand.desktop -t $out/share/applications/
    install -D data/io.github.GourmandRecipeManager.Gourmand.svg -t $out/share/icons/hicolor/scalable/apps/
    install -D data/io.github.GourmandRecipeManager.Gourmand.appdata.xml -t $out/share/appdata/

    substituteInPlace $out/share/applications/io.github.GourmandRecipeManager.Gourmand.desktop \
      --replace "Exec=gourmand" "Exec=$out/bin/gourmand"
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # we skip anything upstream ci doesn't run, and also the web scraping plugin
  # tests, since we do not enable the optional web scrape feature
  checkPhase = ''
    export HOME=$(mktemp -d)
    LANGUAGE=de_DE xvfb-run -a pytest -vv \
      --ignore-glob='tests/test_*_plugin.py' \
      --ignore=tests/broken \
      --ignore=tests/dogtail \
      --ignore=tests/old_databases \
      --ignore=tests/recipe_files \
      --ignore tests/test_db.py \
      tests/
  '';

  meta = with lib; {
    description = "Desktop recipe manager";
    longDescription = ''
      Gourmand Recipe Manager is a desktop cookbook application for editing and organizing recipes. It is a fork of the Gourmet Recipe Manager.
    '';
    homepage = "https://github.com/GourmandRecipeManager/gourmand";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
