{
  stdenv,
  lib,
  fetchFromGitHub,
  libXext,
  libX11,
  IOKit,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spacenavd";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-26geQYOXjMZZ/FpPpav7zfql0davTBwB4Ir+X1oep9Q=";
  };

  buildInputs = [
    libX11
    libXext
  ] ++ lib.optional stdenv.hostPlatform.isDarwin IOKit;

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
