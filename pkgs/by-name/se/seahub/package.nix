{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
  nixosTests,
  seafile-server,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "seahub";
  version = "13.0.21";
  pyproject = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";

    # Using a fixed revision because upstream may re-tag releases.
    rev = "43e6424d2285ea9da6e7168c4e61732b36ad30b5";
    hash = "sha256-XoxHCiQZtTRXD7T9bL63Y78PAOmhbQeGGu5u82ic+uw=";
  };

  dontBuild = true;

  doCheck = false; # requires a running seafile environment

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    django
    django-statici18n
    django-webpack-loader
    django-picklefield
    django-formtools
    django-simple-captcha
    captcha
    djangorestframework
    mysqlclient
    pillow
    pillow-heif
    python-dateutil
    requests
    requests-oauthlib
    chardet
    pyjwt
    pycryptodome
    pyopenssl
    python-ldap
    qrcode
    pysearpc
    gunicorn
    markdown
    bleach
    openpyxl
    cffi
    redis
    cairosvg
    pypinyin
    dnspython

    (python3.pkgs.toPythonModule (seafile-server.override { inherit python3; }))
  ];

  postPatch = ''
    substituteInPlace seahub/settings.py \
      --replace-fail "SEAFILE_VERSION = '6.3.3'" "SEAFILE_VERSION = '${finalAttrs.version}'"
  '';

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python3;
    inherit seafile-server;

    pythonPath = python3.pkgs.makePythonPath finalAttrs.propagatedBuildInputs;
    tests = {
      inherit (nixosTests) seafile;
    };
  };

  meta = {
    description = "Web frontend for the Seafile file sync and share server";
    homepage = "https://github.com/haiwen/seahub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.linux;
  };
})
