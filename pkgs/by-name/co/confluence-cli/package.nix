{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "confluence-cli";
  version = "2.1.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pchuri";
    repo = "confluence-cli";
    rev = "v${version}";
    hash = "sha256-iTC1kenUQXYLnZ1KxhMaXeEJF2tih8HjlOsxq1Xtjds=";
  };

  npmDepsHash = "sha256-T06O6M2hjp9v32FKgVATQ42nhHVEN5+Rv2GcXkdp7zI=";

  dontNpmBuild = true;

  meta = {
    description = "Command-line interface for Atlassian Confluence";
    homepage = "https://github.com/pchuri/confluence-cli";
    license = lib.licenses.mit;
    mainProgram = "confluence";
    maintainers = [ ];
  };
}
