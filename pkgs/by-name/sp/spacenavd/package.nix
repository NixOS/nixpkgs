{
  stdenv,
  lib,
  fetchFromGitHub,
  libxext,
  libx11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spacenavd";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nqfu5Byd9ObPym3fjKdeAsAYqjN++33mX30onKhvOk0=";
  };

  buildInputs = [
    libx11
    libxext
  ];

  configureFlags = [ "--disable-debug" ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  postInstall = ''
    install -Dm644 $src/contrib/systemd/spacenavd.service -t $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/spacenavd.service \
      --replace-fail "/usr/local/bin/spacenavd" "$out/bin/spacenavd"
  '';

  meta = {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sohalt ];
  };
})
