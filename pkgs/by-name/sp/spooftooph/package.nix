{
  lib,
  stdenv,
  fetchurl,
  bluez,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spooftooph";
  version = "0.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/spooftooph/spooftooph-${finalAttrs.version}/spooftooph-${finalAttrs.version}.tar.gz";
    hash = "sha256-JH5+fHpe83NJV9AR5MXKnrwaTqz4s2BGAcczbddVNHw=";
  };

  buildInputs = [
    bluez
    ncurses
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";

  makeFlags = [ "BIN=$(out)/bin" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/spooftooph";
    description = "Automate spoofing or clone Bluetooth device Name, Class, and Address";
    mainProgram = "spooftooph";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
