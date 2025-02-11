{
  lib,
  cmake,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httplib";
  version = "0.18.7";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DkET7D2hF6xlrYWEGC87rFqEe1JjMS3SHX6QFSi1oQg=";
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
