{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  gcc,
  icu,
  nix-update-script,
  nixosTests,
  pkg-config,
  python3,
  sqlite,
  stdenv,
  uwsgi,
}:
let
  version = "1.45.0";

  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_6;
    };
  };

  uwsgiWithPython = uwsgi.override {
    plugins = [ "python3" ];
    python3 = python;
  };

  # Compile the SQLite ICU extension for case-insensitive search and ordering.
  # This mirrors the compile-icu stage in the upstream Dockerfile.
  icuExtension = stdenv.mkDerivation {
    pname = "linkding-sqlite-icu";
    inherit version;

    src = fetchurl {
      url = "https://www.sqlite.org/src/raw/ext/icu/icu.c?name=91c021c7e3e8bbba286960810fa303295c622e323567b2e6def4ce58e4466e60";
      name = "icu.c";
      hash = "sha256-DkELE5p82yZVz0GVFdWWAEU8eo10ob0fqx66Q7rxv+U=";
    };

    nativeBuildInputs = [
      gcc
      pkg-config
    ];

    buildInputs = [
      icu.dev
      sqlite.dev
    ];

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild
      gcc -fPIC -shared $src \
        -I${sqlite.dev}/include \
        $(pkg-config --libs --cflags icu-uc icu-io) \
        -o libicu.so
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 libicu.so $out/lib/libicu.so
      runHook postInstall
    '';
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "linkding";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sissbruecker";
    repo = "linkding";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iGvUKmOPL0akfR52hzSGH6wu06/WP9ygiQ/HxsmrYWg=";
  };

  __structuredAttrs = true;

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    beautifulsoup4
    bleach
    bleach-allowlist
    django
    djangorestframework
    huey
    markdown
    mozilla-django-oidc
    requests
    waybackpy
  ];

  optional-dependencies = {
    postgres = with python.pkgs; [ psycopg ];
  };

  dontCheckRuntimeDeps = true;
  # Django's runserver re-executes sys.argv[0] via the Python interpreter,
  # so manage.py must remain a valid Python script and cannot be wrapped in bash.
  dontWrapPythonPrograms = true;

  pyprojectAppendix = ''
    [tool.setuptools.packages.find]
    include = ["bookmarks*"]
    [tool.setuptools.package-data]
    bookmarks = ["static/**/*", "styles/**/*", "templates/**/*", "version.txt"]
  '';

  ui = buildNpmPackage {
    inherit (finalAttrs) version;

    pname = "${finalAttrs.pname}-ui";
    src = finalAttrs.src;

    npmDepsHash = "sha256-zUMgl+h0BPm9QzGi1WZG8f0tDoYk8p+Al3q6uEKXqLk=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bookmarks
      mv bookmarks/static $out/bookmarks
      runHook postInstall
    '';
  };

  postPatch = ''
    echo "$pyprojectAppendix" >> pyproject.toml

    # Point the SQLite ICU extension to its store path so it is found
    # regardless of the working directory at runtime.
    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        'SQLITE_ICU_EXTENSION_PATH = "./libicu.so"' \
        'SQLITE_ICU_EXTENSION_PATH = "${icuExtension}/lib/libicu.so"'

    # Allow overriding the data directory via an internal environment variable
    # so that the NixOS module can point it at the mutable state directory
    # (/var/lib/linkding). The variable name is intentionally NixOS-specific
    # and not a real linkding option to avoid confusing users.
    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        'BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))' \
            'BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))''\nDATA_DIR = os.getenv("_NIXOS_LINKDING_DATA_DIR", os.path.join(os.getcwd(), "data"))'

    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        '"filename": os.path.join(BASE_DIR, "data", "tasks.sqlite3"),' \
        '"filename": os.path.join(DATA_DIR, "tasks.sqlite3"),'

    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        '"NAME": os.path.join(BASE_DIR, "data", "db.sqlite3"),' \
        '"NAME": os.path.join(DATA_DIR, "db.sqlite3"),'

    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        'LD_FAVICON_FOLDER = os.path.join(BASE_DIR, "data", "favicons")' \
        'LD_FAVICON_FOLDER = os.path.join(DATA_DIR, "favicons")'

    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        'LD_PREVIEW_FOLDER = os.path.join(BASE_DIR, "data", "previews")' \
        'LD_PREVIEW_FOLDER = os.path.join(DATA_DIR, "previews")'

    substituteInPlace bookmarks/settings/base.py \
      --replace-fail \
        'LD_ASSET_FOLDER = os.path.join(BASE_DIR, "data", "assets")' \
        'LD_ASSET_FOLDER = os.path.join(DATA_DIR, "assets")'

    substituteInPlace bookmarks/utils.py \
      --replace-fail \
        'import datetime' \
        'import datetime''\nimport os'

    substituteInPlace bookmarks/utils.py \
      --replace-fail \
        'with open("version.txt") as f:' \
        'with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "version.txt")) as f:'

    substituteInPlace bookmarks/settings/prod.py \
      --replace-fail \
        'with open(os.path.join(BASE_DIR, "data", "secretkey.txt")) as f:' \
        'with open(os.path.join(DATA_DIR, "secretkey.txt")) as f:'

    substituteInPlace bookmarks/settings/dev.py \
      --replace-fail \
        'os.path.join(BASE_DIR, "data", "favicons"),' \
        'os.path.join(DATA_DIR, "favicons"),'

    substituteInPlace bookmarks/settings/dev.py \
      --replace-fail \
        'os.path.join(BASE_DIR, "data", "previews"),' \
        'os.path.join(DATA_DIR, "previews"),'

    # Patch management commands that bypass Django settings and use hardcoded
    # relative "data/" paths. Replace them with paths derived from DATA_DIR
    # via django.conf.settings so the data directory is always correct.
    substituteInPlace bookmarks/management/commands/generate_secret_key.py \
      --replace-fail \
        'from django.core.management.utils import get_random_secret_key' \
        'from django.conf import settings''\nfrom django.core.management.utils import get_random_secret_key'
    substituteInPlace bookmarks/management/commands/generate_secret_key.py \
      --replace-fail \
        'secret_key_file = os.path.join("data", "secretkey.txt")' \
        'secret_key_file = os.path.join(settings.DATA_DIR, "secretkey.txt")'
    substituteInPlace bookmarks/management/commands/migrate_tasks.py \
      --replace-fail \
        'import sqlite3' \
        'import sqlite3''\nfrom django.conf import settings'
    substituteInPlace bookmarks/management/commands/migrate_tasks.py \
      --replace-fail \
        'db = sqlite3.connect(os.path.join("data", "db.sqlite3"))' \
        'db = sqlite3.connect(os.path.join(settings.DATA_DIR, "db.sqlite3"))'

    # Place the version.txt file inside of the bookmarks package
    # so that it can be installed by setuptools alongside the package
    # in the Nix store.
    mv version.txt bookmarks/version.txt
  '';

  preBuild = ''
    cp -r ${finalAttrs.ui}/bookmarks/static/* bookmarks/static
  '';

  # Collect static files at build time so the result is a pure store path
  # that can be served directly by the NixOS module without any runtime step.
  # STATIC_ROOT in base.py defaults to $PWD/static, so the collected files
  # land there and are picked up by postInstall.
  postBuild = ''
    mkdir data
    ${python.interpreter} manage.py collectstatic --no-input
  '';

  postInstall =
    let
      pythonPath = python.pkgs.makePythonPath finalAttrs.passthru.dependencies;
    in
    ''
      mkdir $out/bin

      cp -r static/* $out/${python.sitePackages}/bookmarks/static

      cp ./manage.py $out/bin/.manage.py
      chmod +x $out/bin/.manage.py

      makeWrapper $out/bin/.manage.py $out/bin/linkding \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"

      # Bootstrap script mirroring the upstream bootstrap.sh: creates data
      # directories and runs Django management commands to initialize a fresh
      # linkding installation. The linkding binary is referenced by its
      # absolute store path so the script works without PATH manipulation.
      cat > $out/bin/linkding-bootstrap << EOF
      #!/bin/sh
      DATA_DIR="\''${_NIXOS_LINKDING_DATA_DIR:-data}"
      mkdir -p "\$DATA_DIR"/favicons "\$DATA_DIR"/previews "\$DATA_DIR"/assets
      $out/bin/linkding generate_secret_key
      $out/bin/linkding migrate
      $out/bin/linkding enable_wal
      $out/bin/linkding create_initial_superuser
      $out/bin/linkding migrate_tasks
      EOF
      chmod +x $out/bin/linkding-bootstrap
    '';

  passthru = {
    inherit
      python
      icuExtension
      uwsgiWithPython
      ;
    tests = {
      inherit (nixosTests) linkding linkding-postgres;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "ui"
      ];
    };
  };

  meta = {
    description = "Self-hosted bookmark manager designed to be minimal, fast, and easy to set up";
    homepage = "https://linkding.link/";
    changelog = "https://github.com/sissbruecker/linkding/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      squat
    ];
    platforms = lib.platforms.linux;
  };
})
