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

  makeFlags = [ "BIN=$(out)/bin" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/spooftooph";
    description = "Automate spoofing or clone Bluetooth device Name, Class, and Address";
    mainProgram = "spooftooph";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
})
