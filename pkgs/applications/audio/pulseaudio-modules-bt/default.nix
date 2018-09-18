{ stdenv
, runCommand
, fetchFromGitHub
, libpulseaudio
, pulseaudio
, pkgconfig
, libtool
, cmake
, bluez
, dbus
, sbc
}:

let
  pulseSources = runCommand "pulseaudio-sources" {} ''
    mkdir $out
    tar -xf ${pulseaudio.src}
    mv pulseaudio*/* $out/
  '';

in stdenv.mkDerivation rec {
  name = "pulseaudio-modules-bt-${version}";
  version = "unstable-2018-09-11";

  src = fetchFromGitHub {
    owner = "EHfive";
    repo = "pulseaudio-modules-bt";
    rev = "9c6ad75382f3855916ad2feaa6b40e37356d80cc";
    sha256 = "1iz4m3y6arsvwcyvqc429w252dl3apnhvl1zhyvfxlbg00d2ii0h";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  buildInputs = [
    libpulseaudio
    pulseaudio
    libtool
    bluez
    dbus
    sbc
  ];

  NIX_CFLAGS_COMPILE = [
    "-L${pulseaudio}/lib/pulseaudio"
  ];

  prePatch = ''
    rm -r pa
    ln -s ${pulseSources} pa
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/EHfive/pulseaudio-modules-bt;
    description = "SBC, Sony LDAC codec (A2DP Audio) support for Pulseaudio";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };
}
