{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  chromium,
}:

buildNpmPackage rec {
  pname = "puppeteer-cli";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "JarvusInnovations";
    repo = "puppeteer-cli";
    rev = "v${version}";
    sha256 = "0xrb8r4qc9ds7wmfd30nslnkqylxqfwr4gqf7b30v651sjyds29x";
  };

  npmDepsHash = "sha256-R22lXQuYNQ+TQ7U2l4wZeBmAl8AXHUPG/3qVQBi3Ezo=";

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
  };

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/puppeteer \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  '';

  meta = {
    description = "Command-line wrapper for generating PDF prints and PNG screenshots with Puppeteer";
    homepage = "https://github.com/JarvusInnovations/puppeteer-cli";
    license = lib.licenses.mit;
    mainProgram = "puppeteer";
    maintainers = with lib.maintainers; [ chessai ];
  };
}
