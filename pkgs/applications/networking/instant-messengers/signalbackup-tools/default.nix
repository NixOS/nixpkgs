{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  darwin,
  dbus,
  openssl,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20240924-2";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    rev = version;
    hash = "sha256-YnblQjZpKsnphbaRQ6FyHhssnns7U5VoNe/r3goQ0g8=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
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
