{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "sharing";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "parvardegr";
    repo = "sharing";
    rev = "v${version}";
    hash = "sha256-JDL7LWo2HQGex93m7d37XCVTmcBHGnepMUgOGWoOpD4=";
  };

  npmDepsHash = "sha256-AvlEpO2ySkX7+Qr3Am9jB31E1iuW5MParv0zt50/ib0=";

  dontNpmBuild = true;

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  env.NODE_OPTIONS = "--openssl-legacy-provider";

  meta = {
    description = "Command-line tool to share directories and files to mobile devices";
    homepage = "https://github.com/parvardegr/sharing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ChaosAttractor ];
  };
}
