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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "alot";
  version = "0.12";
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
    tag = "v${finalAttrs.version}";
    hash = "sha256-x2o/VfIeDIWsv0JS0FBWVHEjNaktx1/MjhDnqQSe/IY=";
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
    gpg
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
    python3Packages.pytestCheckHook
  ];

  postBuild =
    let
      docPythonPath = python3Packages.makePythonPath (
        with python3Packages;
        [
          notmuch2
          standard-mailcap
        ]
      );
    in
    lib.optionalString withManpage ''
      PYTHONPATH="$PWD:${docPythonPath}" make -C docs man
    '';

  postInstall =
    let
      completionPython = python3.withPackages (ps: [ ps.configobj ]);
    in
    lib.optionalString withManpage ''
      install -Dm644 docs/build/man/alot.1 -t $man/share/man/man1
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
    changelog = "https://github.com/pazz/alot/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "alot";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ milibopp ];
  };
})
