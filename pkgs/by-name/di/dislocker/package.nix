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
  version = "0.7.4-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "Aorimn";
    repo = "dislocker";
    rev = "21ef6e58deb400502121e80fc0dfc7d9974e364f";
    hash = "sha256-+T+B8pJDvL8sa2zCVl43RMw7M3i2mRD8+vFbEILL0Io=";
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
