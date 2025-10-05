{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "percollate";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "danburzo";
    repo = "percollate";
    rev = "v${version}";
    hash = "sha256-nu72jkqGt2ntlCxKptRlfTTd3SAVlv/QPTwkIUpVd2g=";
  };

  npmDepsHash = "sha256-O74AVF3PwLzkWPAqTmfsxPefevvv3VRIstb0OI2/bQ0=";

  dontNpmBuild = true;

  # Dev dependencies include an unnecessary Java dependency (epubchecker)
  # https://github.com/danburzo/percollate/blob/v4.3.0/package.json#L40
  npmInstallFlags = [ "--omit=dev" ];

  nativeBuildInputs = [ makeWrapper ];

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
  };

  postPatch = ''
    substituteInPlace package.json --replace "git config core.hooksPath .git-hooks" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/percollate \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  '';

  meta = with lib; {
    description = "Command-line tool to turn web pages into readable PDF, EPUB, HTML, or Markdown docs";
    homepage = "https://github.com/danburzo/percollate";
    license = licenses.mit;
    maintainers = [ maintainers.austinbutler ];
    mainProgram = "percollate";
  };
}
