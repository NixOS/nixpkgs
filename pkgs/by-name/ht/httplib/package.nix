{
  lib,
  cmake,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httplib";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FRyc3CmJ8vnv2eSTOpypLXN6XpdzMbD6SEdzpZ2ns3A=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/yhirose/cpp-httplib";
    description = "C++ header-only HTTP/HTTPS server and client library";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
