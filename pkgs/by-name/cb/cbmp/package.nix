{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "cbmp";
  version = "1.1.1";

  # note: updating notes
  # - use `prefetch-npm-deps` package for src hash
  # - use `npm install --package-lock-only`
  #   in the cbmp repo for package-lock generation
  # - update npmDepsHash

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "cbmp";
    rev = "v${version}";
    hash = "sha256-vOEz2KGJLCiiX+Or9y0JE9UF7sYbwaSCVm5iBv4jIdI=";
  };

  npmDepsHash = "sha256-3qYPttKSGlO/T3K3730vVaZ1iYRz+GoBMN2igqGQ8AM=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  meta = {
    description = "CLI App for converting cursor svg file to png";
    homepage = "https://github.com/ful1e5/cbmp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = "cbmp";
  };
}
