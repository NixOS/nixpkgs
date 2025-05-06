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
  version = "20250505";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    rev = version;
    hash = "sha256-LtvR/K+r0Wdnh2b0TkR6mzldF4GKGwKApf4Q+sNj4Ok=";
  };

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
    ];

  buildInputs =
    [
      openssl
      sqlite
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

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    mainProgram = "signalbackup-tools";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
