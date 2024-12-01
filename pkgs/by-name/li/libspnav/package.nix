{
  stdenv,
  lib,
  fetchFromGitHub,
  libX11,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "libspnav";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "libspnav";
    rev = "refs/tags/v${version}";
    hash = "sha256-qBewSOiwf5iaGKLGRWOQUoHkUADuH8Q1mJCLiWCXmuQ=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ libX11 ];

  configureFlags = [ "--disable-debug" ];
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  preInstall = ''
    mkdir -p $out/{lib,include}
  '';

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
}
