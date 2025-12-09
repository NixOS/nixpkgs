{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
  gnupg,
  gawk,
  procps,
  notmuch,
  withManpage ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "alot";
  version = "0.11";
  pyproject = true;

  outputs = [
    "out"
  ]
  ++ lib.optionals withManpage [
    "man"
  ];

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "alot";
    tag = version;
    hash = "sha256-mXaRzl7260uxio/BQ36BCBxgKhl1r0Rc6PwFZA8qNqc=";
  };

  postPatch = ''
    substituteInPlace alot/settings/manager.py \
      --replace-fail /usr/share "$out/share"
  '';

  build-system =
    with python3Packages;
    [
      setuptools
      setuptools-scm
    ]
    ++ lib.optional withManpage sphinx;

  dependencies = with python3Packages; [
    configobj
    gpgme
    notmuch2
    python-magic
    standard-mailcap
    twisted
    urwid
    urwidtrees
  ];

  nativeCheckInputs = [
    gawk
    gnupg
    notmuch
    procps
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    mock
  ]);

  postBuild = lib.optionalString withManpage [
    "make -C docs man"
  ];

  disabledTests = [
    # Some twisted tests need internet access
    "test_env_set"
    "test_no_spawn_no_stdin_attached"
    # DatabaseLockedError
    "test_save_named_query"
  ];

  postInstall =
    let
      completionPython = python3.withPackages (ps: [ ps.configobj ]);
    in
    lib.optionalString withManpage ''
      mkdir -p $out/man
      cp -r docs/build/man $out/man
    ''
    + ''
      mkdir -p $out/share/{applications,alot}
      cp -r extra/themes $out/share/alot

      substituteInPlace extra/completion/alot-completion.zsh \
        --replace-fail "python3" "${completionPython.interpreter}"
      install -D extra/completion/alot-completion.zsh $out/share/zsh/site-functions/_alot

      sed "s,/usr/bin,$out/bin,g" extra/alot.desktop > $out/share/applications/alot.desktop
    '';

  meta = {
    homepage = "https://github.com/pazz/alot";
    description = "Terminal MUA using notmuch mail";
    changelog = "https://github.com/pazz/alot/releases/tag/${src.tag}";
    mainProgram = "alot";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ milibopp ];
  };
}
