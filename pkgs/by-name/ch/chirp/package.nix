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
  version = "0.4.0-unstable-2024-12-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "48c33155d141e0444dd4a73e069422c8a25d51b4";
    hash = "sha256-6FKzdf4GS0XpA5HUIAqdrBaeslOrNhaZqpHMRIagkpI=";
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
    ];
    platforms = lib.platforms.linux;
  };
}
