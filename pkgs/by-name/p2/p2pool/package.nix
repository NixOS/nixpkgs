{
  stdenv,
  cmake,
  curl,
  fetchFromGitHub,
  gss,
  hwloc,
  lib,
  libsodium,
  libuv,
  nix-update-script,
  openssl,
  pkg-config,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "p2pool";
<<<<<<< HEAD
  version = "4.13";
=======
  version = "4.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-HeimLu3KomXVEnd8ChnfsDm0Y48yablLheJQ/yfIl7o=";
=======
    hash = "sha256-Yrc36tibHanXZcE3I+xcmkCzBALE09zi1Zg0Lz3qS2g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libuv
    zeromq
    libsodium
    gss
    hwloc
    openssl
    curl
  ];

  cmakeFlags = [ "-DWITH_LTO=OFF" ];

  installPhase = ''
    runHook preInstall

    install -vD p2pool $out/bin/p2pool

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Decentralized pool for Monero mining";
    homepage = "https://github.com/SChernykh/p2pool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ratsclub
      JacoMalan1
      jk
    ];
    mainProgram = "p2pool";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
