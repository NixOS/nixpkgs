{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "htgettoken";
  version = "2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fermitools";
    repo = "htgettoken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jHKKTnFZ+6LHaB61wi5+Ht6ZHrE4dDqADIMfGWI47oM=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    gssapi
    paramiko
    urllib3
  ];

  meta = {
    description = "Gets OIDC authentication tokens for High Throughput Computing via a Hashicorp vault server ";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/fermitools/htgettoken";
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
