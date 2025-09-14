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
  version = "4.10.1";

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oxUxgooIiesSyew8t/0asa/sEV4I8C+Firp5cLi0fnU=";
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
