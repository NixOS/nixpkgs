{
  lib,
  fetchFromGitHub,
  fetchPypi,
  rustPlatform,
  python3,

  apkid,
  wkhtmltopdf,
  bundletool,
  jadx,
  jdk,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      bcrypt = super.bcrypt.overridePythonAttrs (old: rec {
        version = "4.0.1";
        pname = "bcrypt";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-J9N1kDrIJhz+QEf2cJ0W99GNObHskqr3KvmJVSplDr0=";
        };

        cargoRoot = "src/_bcrypt";
        cargoDeps = rustPlatform.fetchCargoTarball {
          inherit src;
          sourceRoot = "${pname}-${version}/${cargoRoot}";
          name = "${pname}-${version}";
          hash = "sha256-lDWX69YENZFMu7pyBmavUZaalGvFqbHSHfkwkzmDQaY=";
        };
      });

      tzdata = super.tzdata.overridePythonAttrs (old: rec {
        pname = "tzdata";
        version = "2023.4";

        src = fetchPypi {
          inherit pname version;
          hash = "sha256-3VTJTylHZVIsdzmWSbT+/ZVSJHmmZKDOyH9BvrxhSMk=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "mobsf";
  version = "4.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "Mobile-Security-Framework-MobSF";
    #rev = "refs/tags/v${version}";
    # This commit has necessary changes that are not in a published version yet.
    # With the next version this can swap back to normal versioning
    rev = "a015df58712aaeb97d2052b82c2fe94678a6fd04";
    hash = "sha256-jBuL7GPTc+1vDL2KJd89usKJsuvSSWmv/KF/6pyhZQQ=";
    fetchSubmodules = true;
  };

  patches = [
    ./use_home_env_var.patch
    ./handle_migrations.patch
    ./fix_copy_perms.patch
    ./disable_jadx_downloader.patch
  ];

  build-system = [ python.pkgs.poetry-core ];

  dependencies = with python.pkgs; [
    jdk

    wkhtmltopdf

    # Python Deps
    apkid
    apksigtool
    arpy
    bcrypt
    biplist
    beautifulsoup4
    colorlog
    distro
    django
    django-ratelimit
    django-q2
    frida-python
    google-play-scraper
    gunicorn
    http-tools
    ip2location
    libsast
    lief
    lxml
    macholib
    openstep-parser
    paramiko
    pdfkit
    psutil
    psycopg2-binary
    python3-saml
    requests
    rsa
    shelljob
    six
    svgutils
    tldextract
    tzdata
    whitenoise
    pyopenssl
  ];

  # Remove the beautifulsoup4 dummy package requirement
  pythonRemoveDeps = [ "bs4" ];

  makeWrapperArgs = [
    "--set MOBSF_JADX_BINARY ${jadx}/bin/jadx"
    "--set MOBSF_BUNDLE_TOOL ${bundletool}/bin/bundletool"
  ];

  postInstall = ''
    # For some reason it bases a bunch of download scripts we don't want
    # running off of if secret key is set. This secret key will be reset the
    # first time mobsf is run on a system after build
    export MOBSF_SECRET_KEY="DUMMY"
    export MOBSF_USE_HOME="0"

    python manage.py makemigrations
    python manage.py makemigrations StaticAnalyzer

    rm -rf mobsf/StaticAnalyzer/migrations/__pycache__
    install -Dm755 mobsf/StaticAnalyzer/migrations/* -t $out/${python.sitePackages}/mobsf/StaticAnalyzer/migrations
  '';

  meta = {
    description = "Mobile Security Framework (MobSF) is a security research platform for mobile applications in Android, iOS and Windows Mobile.";
    changelog = "https://github.com/MobSF/Mobile-Security-Framework-MobSF/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/MobSF/Mobile-Security-Framework-MobSF";
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
