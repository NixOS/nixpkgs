{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "carbon-now-cli";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mixn";
    repo = "carbon-now-cli";
    rev = "v${version}";
    hash = "sha256-2fqZdPkVM3qBZKacBv9dX99Q9WnM5m7OpChG2n1TnXg=";
  };

  npmDepsHash = "sha256-UgrgnaA+GXRQT3dtAoMq6tsZZ2gV1CQNoYG58IuSZUM=";

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
