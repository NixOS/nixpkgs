{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  apple-sdk_11,
  darwinMinVersionHook,
  dbus,
  openssl,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20241218";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    rev = version;
    hash = "sha256-51tjKKpcAF8zsIy5clllOBXQabFh4Lcaa1IUic9CmJA=";
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
    # Needed for `utimensat` on `x86_64-darwin`
    apple-sdk_11
    (darwinMinVersionHook "11.3")
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
