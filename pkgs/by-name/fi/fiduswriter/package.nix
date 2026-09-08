{
  lib,
  python3Packages,
  fetchFromGitHub,
  callPackage,
  gettext,
  makeWrapper,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fiduswriter";
  version = "4.1.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fiduswriter";
    repo = "fiduswriter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NkFJehSgwYwYUZaznZW63KEXR1wTf+Hpa+8ZM71aZ84=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" "setuptools"
  '';

  nativeBuildInputs = [
    gettext
    makeWrapper
  ];

  build-system = with python3Packages; [
    babel
    setuptools
  ];

  dependencies = with python3Packages; [
    bleach
    channels
    granian
    servestatic
    django
    django-allauth
    django-axes
    django-avatar
    django-otp
    pyotp
    qrcode
    django-js-error-hook
    django-npm-mjs
    django-loginas
    httpx
    httpx-ws
    pillow
    python-magic
    prosemirror
    prosemirror-rs
    watchdog
    autobahn
  ];

  optional-dependencies = with python3Packages; {
    books = [
      fiduswriter-books
    ];
    citation-api-import = [
      fiduswriter-citation-api-import
    ];
    gitrepo-export = [
      fiduswriter-gitrepo-export
    ];
    languagetool = [
      fiduswriter-languagetool
    ];
    mysql = [
      mysqlclient
    ];
    ojs = [
      fiduswriter-ojs
    ];
    orjson = [
      orjson
    ];
    pandoc = [
      fiduswriter-pandoc
    ];
    payment-paddle = [
      fiduswriter-payment-paddle
    ];
    phplist = [
      fiduswriter-phplist
    ];
    postgresql = [
      psycopg2
    ];
    prosemirror-python = [
      prosemirror
    ];
    prosemirror-rust = [
      prosemirror-rs
    ];
    website = [
      fiduswriter-website
    ];
  };

  pythonRelaxDeps = [
    "django"
    "django-avatar"
    "django-loginas"
    "granian"
    "httpx-ws"
    "pyotp"
  ];

  env.FIDUS_OUT_DIR = "${placeholder "out"}/${python3Packages.python.sitePackages}";
  env.PYTHONPATH = "${finalAttrs.passthru.pythonPath}:${finalAttrs.env.FIDUS_OUT_DIR}";

  makeWrapperArgs = [
    "--chdir"
    "${finalAttrs.env.FIDUS_OUT_DIR}/fiduswriter"

    "--set"
    "STATIC_ROOT"
    "${finalAttrs.passthru.frontend}/static-collected"

    "--prefix"
    "PYTHONPATH"
    ":"
    "${finalAttrs.env.PYTHONPATH}"
  ];

  postFixup = ''
    mkdir -p $out/bin

    cp -r ${finalAttrs.passthru.frontend}/static-* $FIDUS_OUT_DIR/fiduswriter

    makeWrapper ${lib.getExe python3Packages.granian} $out/bin/granian \
      "''${makeWrapperArgs[@]}"

    makeWrapper ${lib.getExe python3Packages.granian} $out/bin/fiduswriter-start \
      --add-flags '\
        --interface asgi \
        --host ''${GRANIAN_HOST:-0.0.0.0} \
        --port ''${GRANIAN_PORT:-8000} \
        --access-log \
        fiduswriter.asgi:application \
      ' \
      "''${makeWrapperArgs[@]}"
  '';

  pythonImportsCheck = [
    "fiduswriter"
  ];

  passthru = {
    pythonPath = python3Packages.makePythonPath finalAttrs.passthru.dependencies;
    frontend = callPackage ./frontend.nix { fiduswriter = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Online collaborative editor for academics";
    homepage = "https://github.com/fiduswriter/fiduswriter";
    changelog = "https://github.com/fiduswriter/fiduswriter/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "fiduswriter";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
