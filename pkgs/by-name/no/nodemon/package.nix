{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nodemon";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "remy";
    repo = "nodemon";
    rev = "v${version}";
    hash = "sha256-bAsq1eoeQ03VhNYgdYJQnZRCxyvt46C+3scihGp+9GU=";
  };

  npmDepsHash = "sha256-cZHfaUWhKZYKRe4Foc2UymZ8hTPrGLzlcXe1gMsW1pU=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework for converting Left-To-Right (LTR) Cascading Style Sheets(CSS) to Right-To-Left (RTL)";
    mainProgram = "rtlcss";
    homepage = "https://rtlcss.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
