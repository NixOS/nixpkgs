{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  dbus,
  openssl,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20250305-2";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    rev = version;
    hash = "sha256-y655shDg3gnm5V1qhEbw6l0JzabhALXPeRQxyFhq2Cs=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    mainProgram = "signalbackup-tools";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
