{
  lib,
  fetchFromGitHub,
  writeShellScript,
  glib,
  gsettings-desktop-schemas,
  python3Packages,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication {
  pname = "chirp";
  version = "0.4.0-unstable-2025-03-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "3e663d36f96aef03a58cab81d32122ca14a59343";
    hash = "sha256-ODb+Q1Q+7XF/mX1GY2qItY4OOigguTFF+53vnaO5Ap0=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pyserial
    requests
    yattag
    suds
    lark
    wxpython
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-xdist
    ddt
    pyyaml
  ];

  postPatch = ''
    substituteInPlace chirp/locale/Makefile \
      --replace-fail /usr/bin/find find
  '';

  preBuild = ''
    make -C chirp/locale
  '';

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  # many upstream test failures
  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    tagConverter = writeShellScript "chirp-tag-converter.sh" ''
      sed -e 's/^release_//g' -e 's/_/./g'
    '';
  };

  meta = {
    description = "Free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      emantor
      wrmilling
      nickcao
      ethancedwards8
    ];
    platforms = lib.platforms.unix;
  };
}
