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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
    tag = finalAttrs.version;
    hash = "sha256-phQ7wfSgctfbjFtg1HVNtoVlnC0yIEJy65Mu/hLPjnw=";
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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-Vhe9sMUTs16+lQ8hpt8E4Vmu6n4kkyzir1IM9etYBno=";
  };

  ZSTD_SYS_USE_PKG_CONFIG = true;

  enableParallelBuilding = true;

  # Disable automated version-check
  buildNoDefaultFeatures = true;

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
