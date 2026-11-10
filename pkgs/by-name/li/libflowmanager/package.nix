{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
  libtrace,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libflowmanager";
  version = "3.0.0-3";

  src = fetchFromGitHub {
    owner = "LibtraceTeam";
    repo = "libflowmanager";
    tag = finalAttrs.version;
    hash = "sha256-lQo8F4w+tu0DZgt0pnbEpwcL6buVbAuFoxtwGFXuGX4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
  ];
  buildInputs = [ libtrace ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^([0-9.-]+)$" ]; };

  meta = {
    description = "Library for assigning network packets to flows based on the standard 5-tuple";
    homepage = "https://github.com/LibtraceTeam/libflowmanager";
    changelog = "https://github.com/LibtraceTeam/libflowmanager/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.unix;
  };
})
