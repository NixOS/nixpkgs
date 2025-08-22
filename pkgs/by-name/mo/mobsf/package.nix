{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  ip2location,
  apkid,
  frida-tools,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mobsf";
  pyproject = true;

  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "Mobile-Security-Framework-MobSF";
    tag = "v${version}";
    hash = "sha256-P+LLe8GwQJwGM7iBpw+SFcifze+s1N910CaDRU7T8s8=";
  };

  buildInputs = [ python3.pkgs.poetry-core ];

  dependencies =
    with python3.pkgs;
    [
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
    ] ++ [
      ip2location
      apkid
      frida-tools
    ];

  pythonRelaxDepsHook = [
     "apkid"
     "bcrypt"
     "defusedxml"
     "lief"
     "tzdata"
     "xmlsec"
  ];

  meta = {
    description = "Mobile Security Framework (MobSF) is an automated, all-in-one mobile application (Android/iOS/Windows) pen-testing, malware analysis and security assessment framework capable of performing static and dynamic analysis";
    homepage = "https://github.com/MobSF/Mobile-Security-Framework-MobSF";
    changelog = "https://github.com/MobSF/Mobile-Security-Framework-MobSF/releases/tag/${src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
