{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  glibcLocales,
  installShellFiles,
  python3Packages,
  sphinxHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "khal";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = "khal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pbBdScyYQMdT2NjCk2dKPkR75Zcizzco2IkXpHkgPR8=";
  };

  patches = [
    # https://github.com/pimutils/khal/pull/1418/
    (fetchpatch {
      name = "fix_calendar_popup";
      url = "https://github.com/pimutils/khal/commit/3fadf020bb65c9c95bba46b5d3695c2565cceacd.patch";
      hash = "sha256-KhqP0RLLOXm1d/4rCVAb5f7v0q7N0/U2iM23+TcnJhY=";
    })
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    glibcLocales
    installShellFiles
    sphinxHook
    python3Packages.sphinx-rtd-theme
    python3Packages.sphinxcontrib-newsfeed
  ];

  dependencies = with python3Packages; [
    click
    click-log
    configobj
    freezegun
    icalendar
    lxml
    pkginfo
    vdirsyncer
    python-dateutil
    pytz
    pyxdg
    requests-toolbelt
    tzlocal
    urwid
  ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    hypothesis
    packaging
    pytestCheckHook
    vdirsyncer
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];
  sphinxBuilders = [
    "html"
    "man"
  ];

  postInstall = ''
    # shell completions
    installShellCompletion --cmd khal \
      --bash <(_KHAL_COMPLETE=bash_source $out/bin/khal) \
      --zsh <(_KHAL_COMPLETE=zsh_source $out/bin/khal) \
      --fish <(_KHAL_COMPLETE=fish_source $out/bin/khal)

    # .desktop file
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.hostPlatform.isAarch64;

  env.LC_ALL = "en_US.UTF-8";

  disabledTests = [
    # timing based
    "test_etag"
    "test_bogota"
    "test_event_no_dst"
  ];

  meta = {
    description = "CLI calendar application";
    homepage = "https://lostpackets.de/khal/";
    changelog = "https://github.com/pimutils/khal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
  };
})
