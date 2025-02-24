{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  chromium,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "percollate";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "danburzo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JpdSEockALXtuuMMi5mgD5AXcayojyK0qMMWF+XFfZE=";
  };

  npmDepsHash = "sha256-qWu1YYi4ddpAUtbDxF4YA8OO6BLZ6gfeb4pw0n9BaZw=";

  dontNpmBuild = true;

  # Dev dependencies include an unnecessary Java dependency (epubchecker)
  # https://github.com/danburzo/percollate/blob/v4.2.3/package.json#L40
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
