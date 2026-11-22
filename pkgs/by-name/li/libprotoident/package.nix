{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
  libtrace,
  libflowmanager,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libprotoident";
  version = "2.0.15-2";

  src = fetchFromGitHub {
    owner = "LibtraceTeam";
    repo = "libprotoident";
    tag = finalAttrs.version;
    hash = "sha256-XiZ/UqF11eeeGudNXJqtTfPn5xWvHPKPrgqV7iHii0M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
  ];
  buildInputs = [
    libtrace
    libflowmanager
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^([0-9.-]+)$" ]; };

  meta = {
    description = "Network traffic classification library that requires minimal application payload";
    homepage = "https://github.com/LibtraceTeam/libprotoident";
    changelog = "https://github.com/LibtraceTeam/libprotoident/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.unix;
  };
})
