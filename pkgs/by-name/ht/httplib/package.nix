{
  lib,
  cmake,
  fetchFromGitHub,
  openssl,
  stdenv,
  copyPkgconfigItems,
  makePkgconfigItem,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "httplib";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OLwD7mpwqG7BUugUca+CJpPMaabJzUMC0zYzJK9PBCg=";
  };

  nativeBuildInputs = [
    cmake
    copyPkgconfigItems
  ];

  buildInputs = [ openssl ];

  strictDeps = true;

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "httplib";
      inherit (finalAttrs) version;
      cflags = [ "-I${variables.includedir}" ];
      variables = rec {
        prefix = placeholder "out";
        includedir = "${prefix}/include";
      };
      inherit (finalAttrs.meta) description;
    })
  ];

  meta = {
    homepage = "https://github.com/yhirose/cpp-httplib";
    description = "C++ header-only HTTP/HTTPS server and client library";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fzakaria
    ];
    platforms = lib.platforms.all;
  };
})
