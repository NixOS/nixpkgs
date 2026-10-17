{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fuse3,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dislocker";
  version = "0.7.3-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "Aorimn";
    repo = "dislocker";
    rev = "0706462db88efe8df88150e4c3e4332b808f4581";
    hash = "sha256-lH2BdMcseZDw5gtzY5V0Gyy4MS0I8Vlyb0uZkkZdcbM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fuse3
    openssl
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CRYPTO_BACKEND" "openssl")
  ];

  doCheck = true; # runs some sanity checks against crypto library bindings

  env.CFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage = "https://github.com/Aorimn/dislocker";
    changelog = "https://github.com/Aorimn/dislocker/raw/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      yuannan
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
