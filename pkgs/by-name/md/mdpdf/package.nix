{
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  lib,
  chromium,
}:
buildNpmPackage rec {
  pname = "mdpdf";

  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "elliotblackburn";
    repo = "mdpdf";
    tag = version;
    sha256 = "sha256-g6sk4p88wEQ027e2UXnm+BQQXiawZrAc2hrAIpjX8As=";
  };

  npmDepsHash = "sha256-aoemlFrT7lsBFx3/odspzgqfsoD8Izd/UGn4ickqzFc=";

  nativeBuildInputs = [ makeWrapper ];

  PUPPETEER_SKIP_DOWNLOAD = "true";

  postInstall = ''
    	wrapProgram "$out/bin/mdpdf" --set PUPPETEER_EXECUTABLE_PATH ${lib.escapeShellArg (lib.getExe chromium)}
  '';

  meta = {
    description = "Markdown to PDF command line app with support for stylesheets";
    homepage = "https://github.com/elliotblackburn/mdpdf";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.shimun ];
    mainProgram = "mdpdf";
  };
}
