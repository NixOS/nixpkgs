{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
  libxcrypt,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "asleap";
  version = "0-unstable-2020-11-28";

  src = fetchFromGitHub {
    owner = "joswr1ght";
    repo = "asleap";
    rev = "254acabba34cb44608c9d2dcf7a147553d3d5ba3";
    hash = "sha256-MQjPup3EX7DCXY/zyroTj/+U2GIq12+VQQJD0gru7C8=";
  };

  buildInputs = [
    openssl
    libpcap
    libxcrypt
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 asleap $out/bin/asleap
    install -Dm755 genkeys $out/bin/genkeys

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/zackw/asleap";
    description = "Recovers weak LEAP and PPTP passwords";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "asleap";
    platforms = lib.platforms.linux;
  };
}
