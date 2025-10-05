{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "carbon-now-cli";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mixn";
    repo = "carbon-now-cli";
    rev = "v${version}";
    hash = "sha256-J7H1oofgosFGxoHzcx+UxaRbqGwqrmk6MYmMISpNB6w=";
  };

  npmDepsHash = "sha256-/YWsk+GNfudSG0Rof1eCXeoK6dfyzzQqvWBLkpfahE0=";

  postPatch = ''
    substituteInPlace package.json \
      --replace "bundle/cli.js" "dist/cli.js" \
      --replace "trash " "rm -rf " \
      --replace "npx playwright install --with-deps" "true"
  '';

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
  };

  meta = {
    description = "Beautiful images of your code — from right inside your terminal";
    homepage = "https://github.com/mixn/carbon-now-cli";
    license = lib.licenses.mit;
    mainProgram = "carbon-now";
    maintainers = with lib.maintainers; [ rmcgibbo ];
  };
}
