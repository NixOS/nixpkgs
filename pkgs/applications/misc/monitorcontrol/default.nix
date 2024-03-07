{ lib, fetchurl, stdenv, undmg }:

# This cannot be built from source due to the problematic nature of XCode - so
# this is what it's like when doves cry?

stdenv.mkDerivation rec {
  pname = "MonitorControl";
  version = "4.1.0";

  src = fetchurl {
    url =
      "https://github.com/MonitorControl/${pname}/releases/download/v${version}/MonitorControl.${version}.dmg";
    sha256 = "iaxM9j78Sq1EH5TCY240N+D5bG6quk2dZj8T7nt9ATo=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "MonitorControl.app";

  installPhase = ''
    mkdir -p "$out/Applications/MonitorControl.app"
    cp -R . "$out/Applications/MonitorControl.app"
  '';

  meta = with lib; {
    description = "A macOS system extension to control brightness and volume of external displays with native OSD";
    longDescription = "Controls your external display brightness and volume and shows native OSD. Use menulet sliders or the keyboard, including native Apple keys!";
    homepage = "https://github.com/MonitorControl/MonitorControl#readme";
    license = licenses.mit;
    maintainers = with maintainers; [ cbleslie ];
    platforms = platforms.darwin;
  };
}
