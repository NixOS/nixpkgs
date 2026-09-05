{
  lib,
  fetchFromGitHub,
  python3,
  ip2location,
  apkid,
  frida-tools,
}:
let
  inherit (python3.pkgs)
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
    ;
in
buildPythonApplication (finalAttrs: {
  pname = "mobsf";
  version = "4.4.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "Mobile-Security-Framework-MobSF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DXTV3JMPRDqb7QiCO+k19VeZm+XnEN7VZkkTJHGL9bU=";
  };

  buildInputs = [ poetry-core ];

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

  pythonRemoveDeps = [
    "bs4"
    "ip2location"
  ];

  pythonRelaxDeps = [
    "apkid"
    "bcrypt"
    "defusedxml"
    "lief"
    "tzdata"
    "xmlsec"
    "paramiko"
  ];

  meta = {
    description = "Mobile Security Framework (MobSF) is an automated, all-in-one mobile application (Android/iOS/Windows) pen-testing, malware analysis and security assessment framework capable of performing static and dynamic analysis";
    homepage = "https://github.com/MobSF/Mobile-Security-Framework-MobSF";
    changelog = "https://github.com/MobSF/Mobile-Security-Framework-MobSF/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
