{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspnav";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "libspnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ESzH2pMTGoDI/AAX8Iz/MVhxQD8q5cg9I91ryUi5Ys=";
  };

  buildInputs = [ libx11 ];

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

  meta = {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sohalt ];
  };
})
