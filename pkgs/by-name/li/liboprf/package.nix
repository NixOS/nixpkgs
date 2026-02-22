{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgconf,
  libsodium,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liboprf";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "liboprf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Toja0rR0321i7L1dsB9YxrwNJwKUzuSfK5LLR3tex7U=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    ./no-static.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [ pkgconf ];

  buildInputs = [ libsodium ];

  makeFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library providing OPRF and Threshold OPRF based on libsodium";
    homepage = "https://github.com/stef/liboprf";
    changelog = "https://github.com/stef/liboprf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
  };
})
