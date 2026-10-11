{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "email-oauth2-proxy";
  version = "2025-10-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "email-oauth2-proxy";
    tag = version;
    hash = "sha256-ZWacjTO+2xeZv8lwcU5tFYsF61p7hduPQB1iOCSdeS4=";
  };

  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    cryptography
    prompt-toolkit
    pyasyncore
    pyjwt
    # GUI dependencies
    packaging
    pillow
    pystray
    pywebview
    timeago
  ];

  pythonImportsCheck = [ "emailproxy" ];

  meta = {
    changelog = "https://github.com/simonrob/email-oauth2-proxy/releases/tag/${version}";
    mainProgram = "emailproxy";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "IMAP/POP/SMTP proxy that transparently adds OAuth 2.0 authentication for email clients";
    homepage = "https://github.com/simonrob/email-oauth2-proxy";
    license = with lib.licenses; [ asl20 ];
  };
}
