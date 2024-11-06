{
  lib,
  stdenv,
  fetchFromGitHub,
  glibcLocales,
  installShellFiles,
  python3,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/pimutils/khal/issues/1361
      icalendar = super.icalendar.overridePythonAttrs (old: rec {
        version = "5.0.13";
        src = fetchFromGitHub {
          owner = "collective";
          repo = "icalendar";
          rev = "refs/tags/v${version}";
          hash = "sha256-2gpWfLXR4HThw23AWxY2rY9oiK6CF3Qiad8DWHCs4Qk=";
        };
        patches = [ ];
        build-system = with self; [ setuptools ];
        dependencies = with self; [
          python-dateutil
          pytz
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "khal";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = "khal";
    rev = "refs/tags/v${version}";
    hash = "sha256-YP2kQ/qXPDwvFvlHf+A2Ymvk49dmt5tAnTaOhrOV92M=";
  };

  build-system = with python.pkgs; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    glibcLocales
    installShellFiles
  ];

  dependencies = with python.pkgs; [
    atomicwrites
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

  nativeCheckInputs = with python.pkgs; [
    freezegun
    hypothesis
    packaging
    pytestCheckHook
    vdirsyncer
  ];

  postInstall = ''
    # shell completions
    installShellCompletion --cmd khal \
      --bash <(_KHAL_COMPLETE=bash_source $out/bin/khal) \
      --zsh <(_KHAL_COMPLETE=zsh_source $out/bin/khal) \
      --fish <(_KHAL_COMPLETE=fish_source $out/bin/khal)

    # man page
    PATH="${
      python3.withPackages (
        ps: with ps; [
          sphinx
          sphinxcontrib-newsfeed
        ]
      )
    }/bin:$PATH" \
      make -C doc man
    installManPage doc/build/man/khal.1

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

  meta = with lib; {
    description = "CLI calendar application";
    homepage = "http://lostpackets.de/khal/";
    changelog = "https://github.com/pimutils/khal/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
