{
  lib,
  fetchFromGitHub,
  docutils,
  gettext,
  glibcLocales,
  glib-networking,
  gobject-introspection,
  gtk3,
  python3,
  python3Packages,
  steam-run,
  unzip,
  webkitgtk,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "minigalaxy";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "sharkwouter";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-bpNtdMYBl2dJ4PQsxkhm/Y+3A0dD/Y2XC0VaUYyRhvM=";
  };

  checkPhase = ''
    runHook preCheck
    env HOME=$PWD LC_ALL=en_US.UTF-8 pytest
    runHook postCheck
  '';

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    glib-networking
    gtk3
  ];

  nativeCheckInputs = with python3Packages; [
    glibcLocales
    pytest
    tox
  ];

  pythonPath = [
    docutils
    python3.pkgs.pygobject3
    python3.pkgs.requests
    python3.pkgs.setuptools
    python3.pkgs.simplejson
    steam-run
    unzip
    webkitgtk
  ];

  # Run Linux games using the Steam Runtime by using steam-run in the wrapper
  # FIXME: not working with makeBinaryWrapper
  postFixup = ''
    sed -e 's#exec -a "$0"#exec -a "$0" ${steam-run}/bin/steam-run#' -i $out/bin/minigalaxy
  '';

  meta = with lib; {
    homepage = "https://sharkwouter.github.io/minigalaxy/";
    changelog = "https://github.com/sharkwouter/minigalaxy/blob/${version}/CHANGELOG.md";
    downloadPage = "https://github.com/sharkwouter/minigalaxy/releases";
    description = "A simple GOG client for Linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
