{
  lib,
  dbus,
  fetchFromGitHub,
  nixosTests,
  python3,
  sphinxHook,
  withDocs ? true,
  withMan ? true,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "autosuspend";
  version = "10.1.0";
  pyproject = true;

  outputs = [
    "out"
  ]
  ++ lib.optionals withDocs [ "doc" ]
  ++ lib.optionals withMan [ "man" ];

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "autosuspend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4mByuJ75hd5TEoKxVglAHlYXZSlbAldMwnIianSw8O4=";
  };

  postPatch = ''
    # This mapping triggers network access on docs generation
    substituteInPlace doc/source/conf.py \
      --replace-fail 'intersphinx_mapping' '# intersphinx_mapping'
  '';

  nativeBuildInputs = lib.optionals (withDocs || withMan) (
    [
      sphinxHook
    ]
    ++ finalAttrs.passthru.optional-dependencies.docs
  );

  sphinxBuilders = lib.optionals withDocs [ "html" ] ++ lib.optionals withMan [ "man" ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dbus-python
    icalendar
    jsonpath-ng
    lxml
    mpd2
    psutil
    pygobject3
    python-dateutil
    requests
    requests-file
    tzdata
    tzlocal
  ];

  optional-dependencies = {
    docs = with python3.pkgs; [
      furo
      recommonmark
      sphinx-autodoc-typehints
      sphinx-issues
      sphinxcontrib-plantuml
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    dbus
    freezegun
    pytest-cov-stub
    pytest-datadir
    pytest-httpserver
    pytest-mock
    pytestCheckHook
    python-dbusmock
  ];

  # Disable tests that need root
  disabledTests = [
    "test_smoke"
    "test_multiple_sessions"
  ];

  passthru.tests = {
    inherit (nixosTests) autosuspend;
  };

  meta = {
    description = "Daemon to automatically suspend and wake up a system";
    homepage = "https://autosuspend.readthedocs.io";
    changelog = "https://github.com/languitar/autosuspend/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      bzizou
      anthonyroussel
    ];
    mainProgram = "autosuspend";
    platforms = lib.platforms.linux;
  };
})
