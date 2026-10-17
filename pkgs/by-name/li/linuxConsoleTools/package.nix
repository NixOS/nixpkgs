{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  SDL2,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linuxconsoletools";
  version = "1.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/linuxconsoletools-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-TaKXRceCt9sY9fN8Sed78WMSHdN2Hi/HY2+gy/NcJFY=";
  };

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [
    SDL2
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  installFlags = [ "PREFIX=\"\"" ];

  doInstallCheck = true;

  meta = {
    homepage = "https://sourceforge.net/projects/linuxconsole/";
    description = "Set of tools for joysticks and serial peripherals";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pSub
    ];

    longDescription = ''
      The included tools are:

      ffcfstress(1)  - force-feedback stress test
      ffmvforce(1)   - force-feedback orientation test
      ffset(1)       - force-feedback configuration tool
      fftest(1)      - general force-feedback test
      jstest(1)      - joystick test
      jscal(1)       - joystick calibration tool
      inputattach(1) - connects legacy serial devices to the input layer
    '';
  };
})
