{ lib
, stdenv
, fetchFromGitHub
, glibcLocales
, installShellFiles
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "khal";
<<<<<<< HEAD
  version = "0.11.2";
=======
  version = "0.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-yI33pB/t+UISvSbLUzmsZqBxLF6r8R3j9iPNeosKcYw=";
=======
    hash = "sha256-5wBKo24EKdEUoYhhv1EqMPOjdwUS31d3R24kLdbyvPA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    vdirsyncer
=======
    pkgs.vdirsyncer
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
