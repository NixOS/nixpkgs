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
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "SChernykh";
    repo = "p2pool";
    rev = "v${version}";
    hash = "sha256-UnvMR4s6o8n7K+9hig3iSFtbN/BmR6yqjc64X443ctk=";
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
  };
}
