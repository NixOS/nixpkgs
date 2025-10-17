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

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20251011";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    tag = version;
    hash = "sha256-xa/WHEuK33Tc/p7VFD5fL+h0nPaUfLmmTu/aqLLd6HI=";
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

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    mainProgram = "signalbackup-tools";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
