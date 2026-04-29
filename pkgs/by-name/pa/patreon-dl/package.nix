{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,

  useFFmpeg ? true,
  ffmpeg,

  chromium,
  firefox,
  browser ?
    if lib.meta.availableOn stdenv.hostPlatform chromium && stdenv.hostPlatform.isLinux then
      "chromium"
    else if lib.meta.availableOn stdenv.hostPlatform firefox && stdenv.hostPlatform.isLinux then
      "firefox"
    else
      null, # can be null, chromium, or firefox

  useYtDlp ? false,
  yt-dlp,

  testers,
  patreon-dl,
}:

assert browser == null || browser == "chromium" || browser == "firefox";

let
  browserConfig =
    if browser == "chromium" then
      "--set PUPPETEER_BROWSER chrome --set PUPPETEER_EXECUTABLE_PATH \"${chromium}/bin/chromium-browser\""
    else if browser == "firefox" then
      "--set PUPPETEER_BROWSER firefox --set PUPPETEER_EXECUTABLE_PATH \"${firefox}/bin/firefox\""
    else
      "";
  path = lib.makeBinPath (lib.optional useFFmpeg ffmpeg ++ lib.optional useYtDlp yt-dlp);
  wrapperArgs = "--set PATH \"${path}\" ${browserConfig}";
in

buildNpmPackage rec {
  pname = "patreon-dl";
  version = "3.3.1";
  src = fetchFromGitHub {
    owner = "patrickkfkan";
    repo = "patreon-dl";
    rev = "v${version}";
    hash = "sha256-9mBaQX51T41UW+RM3KXaof6AtnNmszBsOLcbLyvFtI0=";
  };
  PUPPETEER_SKIP_DOWNLOAD = "true";
  npmDepsHash = "sha256-o4H6B8JqmB8J3JJ3Rjg0wNxWoCkmwxyC+Ork+DtBxXQ=";
  postFixup = ''
    for f in $out/bin/*
    do
      wrapProgram $out/bin/patreon-dl ${wrapperArgs}
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = patreon-dl;
    command = "patreon-dl -h";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Tool for downloading content from Patreon feeds";
    homepage = "https://github.com/patrickkfkan/patreon-dl";
    license = licenses.mit;
    maintainers = with maintainers; [ piperswe ];
    platforms = platforms.all;
  };
}
