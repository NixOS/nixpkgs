{
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
  apkid,
  frida-tools,
  jadx,
  jdk_headless,
}:
let
  inherit (python3Packages)
    buildPythonApplication
    poetry-core
    django
    rsa
    requests
    beautifulsoup4
    colorlog
    macholib
    whitenoise
    waitress
    gunicorn
    psutil
    shelljob
    asn1crypto
    distro
    pdfkit
    google-play-scraper
    frida-python
    tldextract
    openstep-parser
    svgutils
    arpy
    apksigtool
    tzdata
    http-tools
    libsast
    paramiko
    six
    python3-saml
    bcrypt
    psycopg2-binary
    lief
    packaging
    django-ratelimit
    django-q2
    defusedxml
    xmlsec
    lxml
    bleach
    ip2location
    ;
in
buildPythonApplication (finalAttrs: {
  pname = "mobsf";
  version = "4.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "Mobile-Security-Framework-MobSF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zICRuK5NI0aPHSW7GAcFXAuLtrbckzRI/0RHJJmRFhw=";
  };

  patches = [
    # Migrations are generated below at build time instead of on first run,
    # which cannot write into the read-only store.
    ./no-runtime-makemigrations.patch
    # Signature databases are copied out of the store into MOBSF_HOME, where
    # MobSF keeps them up to date, so they must not stay read-only.
    ./writable-signatures.patch
    # JADX is taken from nixpkgs instead of downloaded on first run.
    ./no-jadx-download.patch
  ];

  build-system = [ poetry-core ];

  preBuild = ''
    export HOME="$(mktemp -d)"
    export MOBSF_SECRET_KEY=nixpkgs
    ${python3.pythonOnBuildForHost.interpreter} -m django makemigrations StaticAnalyzer \
      --settings mobsf.MobSF.settings --no-header --skip-checks
  '';

  dependencies = [
    django
    rsa
    requests
    beautifulsoup4
    colorlog
    macholib
    whitenoise
    waitress
    gunicorn
    psutil
    shelljob
    asn1crypto
    distro
    pdfkit
    google-play-scraper
    frida-python
    tldextract
    openstep-parser
    svgutils
    arpy
    apksigtool
    tzdata
    http-tools
    libsast
    paramiko
    six
    python3-saml
    bcrypt
    psycopg2-binary
    lief
    packaging
    django-ratelimit
    django-q2
    defusedxml
    xmlsec
    lxml
    bleach
    ip2location
    apkid
    frida-tools
  ];

  pythonRemoveDeps = [ "bs4" ];

  pythonRelaxDeps = [
    "apkid"
    "bcrypt"
    "defusedxml"
    "lief"
    "tzdata"
    "xmlsec"
    "paramiko"
  ];

  # MobSF terminates itself when it cannot find a JDK.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ jdk_headless ]}"
    "--set-default"
    "MOBSF_JADX_BINARY"
    "${jadx}/bin/jadx"
  ];

  meta = {
    description = "Mobile Security Framework (MobSF) is an automated, all-in-one mobile application (Android/iOS/Windows) pen-testing, malware analysis and security assessment framework capable of performing static and dynamic analysis";
    homepage = "https://github.com/MobSF/Mobile-Security-Framework-MobSF";
    changelog = "https://github.com/MobSF/Mobile-Security-Framework-MobSF/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
