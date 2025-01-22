{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  pkg-config,
  rustPlatform,
  bzip2,
  curl,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-cinnabar";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
    rev = finalAttrs.version;
    hash = "sha256-RUrklp2hobHKnBZKVvxMGquNSZBG/rVWaD/m+7AWqHo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    bzip2
    curl
    zlib
    zstd
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-fTwHwZsBvp2F4w5reF94imaXnsw7xfgJQlGRZ3ztnK8=";
  };

  ZSTD_SYS_USE_PKG_CONFIG = true;

  enableParallelBuilding = true;

  # Disable automated version-check
  buildNoDefaultFeatures = true;
  checkNoDefaultFeatures = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -v target/release/git-cinnabar $out/bin
    ln -sv git-cinnabar $out/bin/git-remote-hg

    runHook postInstall
  '';

  meta = {
    description = "git remote helper to interact with mercurial repositories";
    homepage = "https://github.com/glandium/git-cinnabar";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.all;
  };
})
