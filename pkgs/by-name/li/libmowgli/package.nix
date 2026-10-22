{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmowgli";
  version = "2.1.3-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "libmowgli-2";
    rev = "35d10d758d5aec35c9265640969e5d1dd32f975b";
    hash = "sha256-6jGGUhwFN9zb+oAuVBzW6GbeNn3iaNm3QxfTsUvBM2w=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Development framework for C providing high performance and highly flexible algorithms";
    homepage = "https://github.com/atheme/libmowgli-2";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
