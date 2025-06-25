{
  stdenv,
  lib,
  fetchFromGitHub,
  libXext,
  libX11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spacenavd";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O6gkd+9iW6X8eMN99Ajz9Z0tqZBtbVEYDb67yI1b/Bk=";
  };

  buildInputs = [
    libX11
    libXext
  ];

  configureFlags = [ "--disable-debug" ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  postInstall = ''
    install -Dm644 $src/contrib/systemd/spacenavd.service -t $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/spacenavd.service \
      --replace-fail "/usr/local/bin/spacenavd" "$out/bin/spacenavd"
  '';

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
})
