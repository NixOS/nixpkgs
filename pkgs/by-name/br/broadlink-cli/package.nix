{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "broadlink-cli";
  version = "0.19.0";

  # the tools are available as part of the source distribution from GH but
  # not pypi, so we have to fetch them here.
  src = fetchFromGitHub {
    owner = "mjg59";
    repo = "python-broadlink";
    tag = finalAttrs.version;
    sha256 = "sha256-fqhi4K8Ceh8Rs0ExteCfAuVfEamFjMCjCFm6DRAJDmI=";
  };

  pyproject = false;

  propagatedBuildInputs = with python3Packages; [
    broadlink
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin cli/broadlink_{cli,discovery}
    install -Dm444 -t $out/share/doc/broadlink cli/README.md

    runHook postInstall
  '';

  meta = {
    description = "Tools for interfacing with Broadlink RM2/3 (Pro) remote controls, A1 sensor platforms and SP2/3 smartplugs";
    maintainers = with lib.maintainers; [ peterhoeg ];
    inherit (python3Packages.broadlink.meta) homepage license;
  };
})
