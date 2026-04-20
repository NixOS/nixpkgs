{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  darwinMinVersionHook,
  dbus,
  openssl,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "signalbackup-tools";
  version = "20260413";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    tag = finalAttrs.version;
    hash = "sha256-O6hi1L0oMXCJ0MiNZNObcwpszpGdv9gp0gKCjEXZtHw=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "13.3")
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Tool to work with Signal Backup files";
    mainProgram = "signalbackup-tools";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.malo ];
    platforms = lib.platforms.all;
  };
})
