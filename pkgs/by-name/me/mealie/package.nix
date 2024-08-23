{ lib
, callPackage
, fetchFromGitHub
, fetchpatch
, makeWrapper
, nixosTests
, python3Packages
, stdenv
, writeShellScript
}:

let
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "mealie-recipes";
    repo = "mealie";
    rev = "v${version}";
    sha256 = "sha256-Kc49XDWcZLeJaYgiAO2/mHeVSOLMeiPr3U32e0IYfdU=";
  };

  frontend = callPackage (import ./mealie-frontend.nix src version) { };

  pythonpkgs = python3Packages.override {
    overrides = self: super: {
      pydantic = python3Packages.pydantic_1;
    };
  };
  python = pythonpkgs.python;

  crfpp = stdenv.mkDerivation {
    pname = "mealie-crfpp";
    version = "unstable-2024-02-12";
    src = fetchFromGitHub {
      owner = "mealie-recipes";
      repo = "crfpp";
      rev = "c56dd9f29469c8a9f34456b8c0d6ae0476110516";
      hash = "sha256-XNps3ZApU8m07bfPEnvip1w+3hLajdn9+L5+IpEaP0c=";
    };
  };

  mealie_patch = { name, commit, hash }: fetchpatch {
    inherit name hash;
    url = "https://github.com/mealie-recipes/mealie/commit/${commit}.patch";
  };

in pythonpkgs.buildPythonPackage rec {
  pname = "mealie";
  inherit version src;
  pyproject = true;

  patches = [
    # See https://github.com/mealie-recipes/mealie/pull/3102
    # Replace hardcoded paths in code with environment variables (meant for inside Docker only)
    # So we can configure easily where the data is stored on the server
    (mealie_patch {
      name = "model-path.patch";
      commit = "e445705c5d26b895d806b96b2f330d4e9aac3723";
      hash = "sha256-cf0MwvT81lNBTjvag8UUEbXkBu8Jyi/LFwUcs4lBVcY=";
    })
    (mealie_patch {
      name = "alembic-cfg-path.patch";
      commit = "06c528bfac0708af66aa0629f2e2232ddf07768f";
      hash = "sha256-IOgdZK7dmWeX2ox16J9v+bOS7nHgCMvCJy6RNJLj0p8=";
    })
    ./mealie-logs-to-stdout.patch
  ];

  nativeBuildInputs = [
    pythonpkgs.poetry-core
    pythonpkgs.pythonRelaxDepsHook
    makeWrapper
  ];

  dontWrapPythonPrograms = true;

  doCheck = false;
  pythonRelaxDeps = true;

  propagatedBuildInputs = with pythonpkgs; [
    aiofiles
    alembic
    aniso8601
    appdirs
    apprise
    bcrypt
    extruct
    fastapi
    gunicorn
    html2text
    httpx
    jinja2
    lxml
    orjson
    paho-mqtt
    passlib
    pillow
    psycopg2
    pyhumps
    pytesseract
    python-dotenv
    python-jose
    python-ldap
    python-multipart
    python-slugify
    pyyaml
    rapidfuzz
    recipe-scrapers
    sqlalchemy
    tzdata
    uvicorn
  ];

  postPatch = ''
    substituteInPlace mealie/__init__.py \
      --replace-fail '__version__ = ' '__version__ = "v${version}" #'

    substituteInPlace mealie/services/backups_v2/alchemy_exporter.py \
      --replace-fail 'PROJECT_DIR = ' "PROJECT_DIR = Path('$out') #"

    substituteInPlace mealie/db/init_db.py \
      --replace-fail 'PROJECT_DIR = ' "PROJECT_DIR = Path('$out') #"

    substituteInPlace mealie/services/backups_v2/alchemy_exporter.py \
      --replace-fail '"script_location", path.join(PROJECT_DIR, "alembic")' '"script_location", "${src}/alembic"'
  '';

  postInstall = let
    start_script = writeShellScript "start-mealie" ''
      ${lib.getExe pythonpkgs.gunicorn} "$@" -k uvicorn.workers.UvicornWorker mealie.app:app;
    '';
    init_db = writeShellScript "init-mealie-db" ''
      ${python.interpreter} $OUT/${python.sitePackages}/mealie/scripts/install_model.py
      ${python.interpreter} $OUT/${python.sitePackages}/mealie/db/init_db.py
    '';
  in ''
    mkdir -p $out/config $out/bin $out/libexec
    rm -f $out/bin/*

    substitute ${src}/alembic.ini $out/config/alembic.ini \
      --replace-fail 'script_location = alembic' 'script_location = ${src}/alembic'

    makeWrapper ${start_script} $out/bin/mealie \
      --set PYTHONPATH "$out/${python.sitePackages}:${python.pkgs.makePythonPath propagatedBuildInputs}" \
      --set LD_LIBRARY_PATH "${crfpp}/lib" \
      --set STATIC_FILES "${frontend}" \
      --set PATH "${lib.makeBinPath [ crfpp ]}"

    makeWrapper ${init_db} $out/libexec/init_db \
      --set PYTHONPATH "$out/${python.sitePackages}:${python.pkgs.makePythonPath propagatedBuildInputs}" \
      --set OUT "$out"
  '';

  checkInputs = with python.pkgs; [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit (nixosTests) mealie;
  };

  meta = with lib; {
    description = "A self hosted recipe manager and meal planner";
    longDescription = ''
      Mealie is a self hosted recipe manager and meal planner with a REST API and a reactive frontend
      application built in NuxtJS for a pleasant user experience for the whole family. Easily add recipes into your
      database by providing the URL and Mealie will automatically import the relevant data or add a family recipe with
      the UI editor.
    '';
    homepage = "https://mealie.io";
    changelog = "https://github.com/mealie-recipes/mealie/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ litchipi ];
    mainProgram = "mealie";
  };
}
