{
  stdenv,
  lib,
  fetchFromGitHub,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "libspnav";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "libspnav";
    tag = "v${version}";
    hash = "sha256-4ESzH2pMTGoDI/AAX8Iz/MVhxQD8q5cg9I91ryUi5Ys=";
  };

  buildInputs = [ libX11 ];

  configureFlags = [ "--disable-debug" ];
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "shared=-dynamiclib"
    "shared+=-Wl,-install_name,$(out)/lib/$(lib_so)"
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
