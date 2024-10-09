{
  lib,
  cmake,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httplib";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cR1yRqZ6hZeGtMhiW003zcN0d/f/v1gMMNiL0hA1r6I=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/yhirose/cpp-httplib";
    description = "C++ header-only HTTP/HTTPS server and client library";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      AndersonTorres
    ];
    platforms = lib.platforms.all;
  };
})
