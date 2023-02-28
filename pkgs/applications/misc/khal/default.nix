{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, glibcLocales
, installShellFiles
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "khal";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FneJmoAOb7WjSgluCwlspf27IU3MsQZFKryL9OSSsUw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    glibcLocales
    installShellFiles
  ] ++ (with python3.pkgs; [
    setuptools-scm
    sphinx
    sphinxcontrib_newsfeed
  ]);

  propagatedBuildInputs = with python3.pkgs;[
    atomicwrites
    click
    click-log
    configobj
    freezegun
    icalendar
    lxml
    pkginfo
    pkgs.vdirsyncer
    python-dateutil
    pytz
    pyxdg
    requests-toolbelt
    tzlocal
    urwid
  ];

  nativeCheckInputs = with python3.pkgs;[
    freezegun
    hypothesis
    packaging
    pytestCheckHook
    vdirsyncer
  ];

  patches = [
    # Tests working with latest pytz version, https://github.com/pimutils/khal/pull/1183
    (fetchpatch {
      name = "support-later-pytz.patch";
      url = "https://github.com/pimutils/khal/commit/53eb8a7426d5c09478c78d809c4df4391438e246.patch";
      sha256 = "sha256-drGtvJlQ3qFUdeukRWCFycPSZGWG/FSRqnbwJzFKITc=";
      excludes = [
        "CHANGELOG.rst"
      ];
    })
  ];

  postInstall = ''
    # shell completions
    installShellCompletion --cmd khal \
      --bash <(_KHAL_COMPLETE=bash_source $out/bin/khal) \
      --zsh <(_KHAL_COMPLETE=zsh_source $out/bin/khal) \
      --fish <(_KHAL_COMPLETE=fish_source $out/bin/khal)

    # man page
    PATH="${python3.withPackages (ps: with ps; [ sphinx sphinxcontrib_newsfeed ])}/bin:$PATH" \
    make -C doc man
    installManPage doc/build/man/khal.1

    # .desktop file
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.isAarch64;

  LC_ALL = "en_US.UTF-8";

  disabledTests = [
    # timing based
    "test_etag"
    "test_bogota"
    "test_event_no_dst"
  ];

  meta = with lib; {
    description = "CLI calendar application";
    homepage = "http://lostpackets.de/khal/";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    broken = stdenv.isDarwin;
  };
}
