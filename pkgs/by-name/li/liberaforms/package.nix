{
  lib,
  python3Packages,
  fetchFromCodeberg,

  makeBinaryWrapper,
  moreutils,
  dart-sass,
  postgresql,
  libxml2,
  libxslt,

  # tests
  postgresqlTestHook,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "liberaforms";
  version = "4.9.2";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "LiberaForms";
    repo = "server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nhZvaoJ+qlvtohqE2K8wj6/UHMc9o/tuoNpeq++DzZ8=";
  };

  patches = [
    ./cache-dir.patch
    ./sqlalchemy2.patch
    ./writable-brand-dir.patch
  ];

  postPatch = ''
    sed -i liberaforms/config/config.py \
      -e '/SQLALCHEMY_DATABASE_URI =/s|= .\+|= "postgresql+psycopg2://"|'

    substituteInPlace liberaforms/config/config.py \
      --replace-fail "UPLOADS_DIR = os.path.join(ROOT_DIR, 'uploads')" \
                     "UPLOADS_DIR = os.getenv('UPLOADS_DIR', os.path.join(ROOT_DIR, 'uploads'))"

    substituteInPlace liberaforms/commands/database.py \
      --replace-fail "Migrate(app, db)" \
                     "Migrate(app, db, directory=os.environ.get('MIGRATIONS_DIR', 'migrations'))"
  '';

  # postPatch = ''
  #   echo "Compiling sass files"
  #   pushd liberaforms/static
  #   chronic sass sass:css --style=compressed --no-source-map
  #   popd
  # '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    bleach
    cairosvg
    cryptography
    data-password-entropy
    email-validator
    feedgen
    flask
    flask-assets
    flask-babel
    flask-limiter
    flask-login
    flask-marshmallow
    flask-migrate
    flask-session
    flask-sqlalchemy
    flask-wtf
    gunicorn
    ldap3
    lxml
    markdown
    marshmallow-sqlalchemy
    minio
    passlib
    pillow
    prometheus-client
    psycopg2
    pyjwt
    pypng
    pyqrcode
    python-magic
    unicodecsv
    unidecode
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    dart-sass
    moreutils # chronic
    postgresql
    libxml2
    libxslt
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/liberaforms
    cp -r . $out/share/liberaforms

    mkdir -p $out/bin
    makeWrapper ${python3Packages.python.interpreter} $out/bin/liberaforms \
      --prefix PYTHONPATH : "$out/share/liberaforms:$PYTHONPATH" \
      --add-flags '-m gunicorn liberaforms:create_app()'
    makeWrapper ${lib.getExe python3Packages.flask} $out/bin/liberaforms-flask \
      --prefix PYTHONPATH : "$out/share/liberaforms:$PYTHONPATH" \
      --set MIGRATIONS_DIR "$out/share/liberaforms/migrations" \
      --add-flags '--app liberaforms:create_app()'

    runHook postInstall
  '';

  doCheck = true;

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ]
  ++ (with python3Packages; [
    beautifulsoup4
    deepdiff
    factory-boy
    faker
    polib
    pytest-dotenv
    pytestCheckHook
    requests
  ]);

  # Run pytest on the installed version. A running postgres database server is needed.
  preCheck = ''
    export LANG=C.UTF-8
    export PGUSER=db_user
    export postgresqlEnableTCP=1
    pushd tests
    cp test.ini.example test.ini
  '';

  # # avoid writing in the migration process
  # postFixup = ''
  #   cp $out/assets/brand/logo-default.png $out/assets/brand/logo.png
  #   cp $out/assets/brand/favicon-default.ico $out/assets/brand/favicon.ico
  #   sed -i "/shutil.copyfile/d" $out/liberaforms/models/site.py
  #   sed -i "/brand_dir/d" $out/migrations/versions/6f0e2b9e9db3_.py
  # '';

  meta = {
    description = "Ethical form software";
    homepage = "https://liberaforms.org";
    donationPage = "https://opencollective.com/liberaforms";
    downloadPage = "https://codeberg.org/LiberaForms/server/tags";
    changelog = "https://codeberg.org/LiberaForms/server/releases/tag/v${finalAttrs.src.rev}";
    mainProgram = "liberaforms";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
  };
})
