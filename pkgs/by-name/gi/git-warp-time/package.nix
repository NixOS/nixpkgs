{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  zstd,
  pkg-config,
  jq,
  cargo,
  rustc,
  rustPlatform,

  # buildInputs
  libgit2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-warp-time";
  version = "0.8.4";

  src = fetchurl {
    url = "https://github.com/alerque/git-warp-time/releases/download/v${finalAttrs.version}/git-warp-time-${finalAttrs.version}.tar.zst";
    hash = "sha256-Xh30nA77cJ7+UfKlIslnyD+93AtnQ+8P3sCFsG0DAUk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    nativeBuildInputs = [ zstd ];
    hash = "sha256-bmClqtH1xU2KOKVbCOrgN14jpLKiA2ZMzWwrOiufwnQ=";
  };

  nativeBuildInputs = [
    zstd
    pkg-config
    jq
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libgit2
  ];

  env = {
    LIBGIT2_NO_VENDOR = "1";
  };

  outputs = [
    "out"
    "doc"
    "man"
    "dev"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Utility to reset filesystem timestamps based on Git history";
    longDescription = ''
      A CLI utility that resets the timestamps of files in a Git repository
      working directory to the exact timestamp of the last commit which
      modified each file.
    '';
    homepage = "https://github.com/alerque/git-warp-time";
    changelog = "https://github.com/alerque/git-warp-time/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      alerque
    ];
    license = lib.licenses.gpl3Only;
    mainProgram = "git-warp-time";
  };
})
