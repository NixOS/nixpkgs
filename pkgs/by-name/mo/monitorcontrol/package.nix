{
  lib,
  fetchurl,
  stdenv,
  undmg,
}:

# This cannot be built from source due to the problematic nature of XCode - so
# this is what it's like when doves cry?

stdenv.mkDerivation rec {
  pname = "MonitorControl";
  version = "4.3.3";

  src = fetchurl {
    url = "https://github.com/MonitorControl/${pname}/releases/download/v${version}/MonitorControl.${version}.dmg";
    hash = "sha256-myx3adoU3FYYrs6LFRSiXtwSsoaujjQ/PYgAF/Xuk2g=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "MonitorControl.app";

  unpackCmd = ''
    runHook preUnpack
    undmg $src
    runHook postUnpack
  '';

  installPhase = ''
    mkdir -p "$out/Applications/MonitorControl.app"
    cp -R . "$out/Applications/MonitorControl.app"
  '';

  meta = with lib; {
    description = "MacOS system extension to control brightness and volume of external displays with native OSD";
    longDescription = "Controls your external display brightness and volume and shows native OSD. Use menulet sliders or the keyboard, including native Apple keys!";
    homepage = "https://github.com/MonitorControl/MonitorControl#readme";
    license = licenses.mit;
    maintainers = with maintainers; [
      cbleslie
      cottand
    ];
    platforms = platforms.darwin;
  };
}
