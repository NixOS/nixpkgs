{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "gsts";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "ruimarinho";
    repo = "gsts";
    rev = "v${version}";
    hash = "sha256-J8hd1Z6m81N9wj6I/A3chkW57NQRr0EGVtrbhrVyxjg=";
  };

  npmDepsHash = "sha256-yl4Zo+tyBbKngcMGkcy2k620jHtL7wxDYEJKYeyAGQY=";

  dontNpmBuild = true;
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  meta = {
    description = "Obtain and store AWS STS credentials to interact with Amazon services by authenticating via G Suite SAML.";
    homepage = "https://github.com/ruimarinho/gsts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
