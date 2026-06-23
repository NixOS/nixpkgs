{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
  fetchPnpmDeps,
  makeWrapper,
  rsync,
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    postPatch = finalAttrs.postPatch + "";
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-8JqolPCb9HtfCIgRfM5a3BGozh4alYmEWuWSBUykAZg=";

    nativeBuildInputs = [
      nodejs
      rsync
    ];

    env.PYTHONPATH = "${finalAttrs.passthru.pythonPath}";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" "setuptools"

    # Upstream uses a `package.json5` file for multiple components, each with
    # its own dependencies. To merge all of them into a single `package.json`
    # and get the associated lockfile, run: `python manage.py npm_install`
    mkdir -p .transpile
    cp ${./pnpm-lock.yaml} ./pnpm-lock.yaml
    cp ${./package.json} ./package.json
  '';

  nativeBuildInputs = [
    gettext
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_11
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

  preBuild = ''
    pushd fiduswriter || true
    cp configuration-default.py configuration.py
    python manage.py setup # migrations, npm install, transpilation
    python manage.py collectstatic
    popd
  '';

  env.FIDUS_OUT_DIR = "${placeholder "out"}/${python3Packages.python.sitePackages}";
  env.PYTHONPATH = "${finalAttrs.passthru.pythonPath}";

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "${finalAttrs.passthru.pythonPath}:${finalAttrs.env.FIDUS_OUT_DIR}"
  ];

  postFixup = ''
    mkdir -p $out/bin

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
