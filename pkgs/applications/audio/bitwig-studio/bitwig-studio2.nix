{ stdenv, fetchurl, bitwig-studio1,
  xdg_utils, zenity, ffmpeg, pulseaudio }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "2.3.5";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "1v62z08hqla8fz5m7hl9ynf2hpr0j0arm0nb5lpd99qrv36ibrsc";
  };

  runtimeDependencies = [
    pulseaudio
  ];
})
