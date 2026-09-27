{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  boost,
  curl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "levin";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "levin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nzob0xD/02gFmfm86BW9joCWIl+DO3PtP4Ok/GIRm9M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    boost
    curl
  ];

  # require network access
  cmakeFlags = [ "-DLEVIN_BUILD_TESTS=off" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp platforms/linux/levin $out/bin/levin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Levin is the easiest way to support Anna's Archive and spread human knowledge";
    homepage = "https://github.com/bjesus/levin";
    changelog = "https://github.com/bjesus/levin/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    mainProgram = "levin";
  };
})
