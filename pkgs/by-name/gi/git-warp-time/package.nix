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
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/alerque/git-warp-time/releases/download/v${finalAttrs.version}/git-warp-time-${finalAttrs.version}.tar.zst";
    hash = "sha256-bt94Y1EIcLzz1v2Nwyde63y6FWD+iaFkoEYoQpWVWGY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    dontConfigure = true;
    nativeBuildInputs = [ zstd ];
    hash = "sha256-FNt9spOFOSbOgpZnxLl3aIvU6lnIJHaVMoAKxl4lzhU=";
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
