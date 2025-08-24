{
  lib,
  python311,
  fetchFromGitHub,
  file,
  gnupg,
  gawk,
  procps,
  notmuch,
  withManpage ? false,
}:

with python311.pkgs;
buildPythonApplication rec {
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

  build-system = [
    setuptools-scm
  ]
  ++ lib.optional withManpage sphinx;

  dependencies = [
    configobj
    file
    gpgme
    notmuch2
    python-magic
    service-identity
    twisted
    urwid
    urwidtrees
  ];

  nativeCheckInputs = [
    future
    gawk
    gnupg
    mock
    procps
    pytestCheckHook
    notmuch
  ];

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
      completionPython = python.withPackages (ps: [ ps.configobj ]);
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
