{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  chromium,
}:

buildNpmPackage rec {
  pname = "resumed";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "rbardini";
    repo = "resumed";
    rev = "v${version}";
    hash = "sha256-K9F6ZxtqAQSc5Dqeoysish+xeRqDcDG/6Ynx7bTJfl8=";
  };

  npmDepsHash = "sha256-UElS1pEzPv0FnvMGCnqEFBi7JzE8QWRFynkAPHy35FY=";

  dontNpmPrune = true;

  postInstall = ''
    wrapProgram $out/bin/resumed \
      --set PUPPETEER_EXECUTABLE_PATH ${lib.getExe chromium}
  '';

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightweight JSON Resume builder, no-frills alternative to resume-cli";
    homepage = "https://github.com/rbardini/resumed";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "resumed";
  };
}
