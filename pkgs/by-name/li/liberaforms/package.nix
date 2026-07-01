{
  lib,
  fetchFromCodeberg,
  makeBinaryWrapper,
  postgresql,
  postgresqlTestHook,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  dependencies = [
    python3Packages.bleach
    python3Packages.cairosvg
    python3Packages.cryptography
    python3Packages.email-validator
    python3Packages.feedgen
    python3Packages.flask
    python3Packages.flask-assets
    python3Packages.flask-babel
    python3Packages.flask-limiter
    python3Packages.flask-login
    python3Packages.flask-marshmallow
    python3Packages.flask-migrate
    python3Packages.flask-session
    python3Packages.flask-sqlalchemy
    python3Packages.flask-wtf
    python3Packages.gunicorn
    python3Packages.ldap3
    python3Packages.lxml
    python3Packages.markdown
    python3Packages.marshmallow-sqlalchemy
    python3Packages.minio
    python3Packages.passlib
    python3Packages.password-entropy
    python3Packages.pillow
    python3Packages.prometheus-client
    python3Packages.psycopg2
    python3Packages.pyjwt
    python3Packages.pypng
    python3Packages.pyqrcode
    python3Packages.python-magic
    python3Packages.unicodecsv
    python3Packages.unidecode
  ];

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

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
    python3Packages.beautifulsoup4
    python3Packages.deepdiff
    python3Packages.factory-boy
    python3Packages.faker
    python3Packages.polib
    python3Packages.pytestCheckHook
    python3Packages.pytest-dotenv
    python3Packages.requests
  ];

  preCheck = ''
    cd tests
    cp test.ini.example test.ini
  '';

  meta = {
    description = "Ethical form software";
    homepage = "https://liberaforms.org";
    donationPage = "https://opencollective.com/liberaforms";
    downloadPage = "https://codeberg.org/LiberaForms/server/tags";
    changelog = "https://codeberg.org/LiberaForms/server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ prince213 ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "liberaforms";
  };
})
