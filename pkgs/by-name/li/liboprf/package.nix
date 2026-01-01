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
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "liboprf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BH7sLkj7vGtz2kSSuV2+BrwlQJ26s4UTlNL/owJhzCk=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    ./no-static.patch
  ];

  # strip: error: option is not supported for MachO
  postPatch = lib.optionalString stdenv.hostPlatform.isMacho ''
    substituteInPlace makefile \
      --replace-fail "--strip-unneeded" ""
  '';

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
