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

stdenv.mkDerivation rec {
  pname = "p2pool";
  version = "4.9";

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${version}";
    hash = "sha256-nFoR5n6vm6Q1UBxX+3U6O6NExcrM1Mab+WjEOgRSKCE=";
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

  meta = with lib; {
    description = "Decentralized pool for Monero mining";
    homepage = "https://github.com/SChernykh/p2pool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      ratsclub
      JacoMalan1
    ];
    mainProgram = "p2pool";
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
