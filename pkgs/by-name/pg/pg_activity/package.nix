{
  python3Packages,
  fetchFromGitHub,
  lib,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pg_activity";
  version = "3.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dalibo";
    repo = "pg_activity";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-TzY+3RE06TxIrhl75wol9CvZDIz25GfgOx11vkREw2c=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    attrs
    blessed
    humanize
    psutil
    psycopg2
  ];

  pythonImportsCheck = [ "pgactivity" ];

  meta = {
    description = "Top like application for PostgreSQL server activity monitoring";
    mainProgram = "pg_activity";
    homepage = "https://github.com/dalibo/pg_activity";
    license = lib.licenses.postgresql;
    maintainers = with lib.maintainers; [ mausch ];
  };
})
