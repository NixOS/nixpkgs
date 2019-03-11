{ stdenv, fetchFromGitHub, wrapGAppsHook, gtk2, boost, gnome2, scons,
mjpegtools, libdvdread, dvdauthor, gettext, dvdplusrwtools, libxmlxx, ffmpeg,
enca, pkgconfig, fetchpatch }:

let fetchPatchFromAur = {name, sha256}:
fetchpatch {
  inherit name sha256;
  url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=e6cc6bc80c672aaa1a2260abfe8823da299a192c";
}; in
stdenv.mkDerivation rec {
  name = "bombono-${version}";
  version = "1.2.4";
  src = fetchFromGitHub {
    owner = "muravjov";
    repo = "bombono-dvd";
    rev = version;
    sha256 = "1lz1vik6abn1i1pvxhm55c9g47nxxv755wb2ijszwswwrwgvq5b9";
  };

  patches = map fetchPatchFromAur [
    {name="fix_ffmpeg_codecid.patch";	sha256="1asfc0lqzk4gjssrvjmsi1xr53ygnsx2sh7c8yzp5r3j2bagxhp7";}
    {name="fix_ptr2bool_cast.patch";	sha256="0iqzrmbg38ikh4x9cmx0v0rnm7a9lcq0kd8sh1z9yfmnz71qqahg";}
    {name="fix_c++11_literal_warnings.patch";	sha256="1zbf12i77p0j0090pz5lzg4a7kyahahzqssybv7vi0xikwvw57w9";}
    {name="autoptr2uniqueptr.patch";	sha256="0a3wvwfplmqvi8fnj929y85z3h1iq7baaz2d4v08h1q2wbmakqdm";}
    {name="fix_deprecated_boost_api.patch";	sha256="184gdz3w95ihhsd8xscpwvq77xd4il47kvmv6wslax77xyw50gm8";}
    {name="fix_throw_specifications.patch";	sha256="1f5gi3qwm843hsxvijq7sjy0s62xm7rnr1vdp7f242fi0ldq6c1n";}
    {name="fix_operator_ambiguity.patch";	sha256="0r4scsbsqfg6wgzsbfxxpckamvgyrida0n1ypg1klx24pk5dc7n7";}
    {name="fix_ffmpeg30.patch";	sha256="1irva7a9bpbzs60ga8ypa3la9y84i5rz20jnd721qmfqp2yip8dw";}
  ];

  nativeBuildInputs = [ wrapGAppsHook scons pkgconfig gettext ];

  buildInputs = [
    gtk2 gnome2.gtkmm mjpegtools libdvdread dvdauthor boost dvdplusrwtools
    libxmlxx ffmpeg enca
    ];

  prefixKey = "PREFIX=";

  enableParallelBuilding = true;

  meta = {
    description = "a DVD authoring program for personal computers";
    homepage = "http://www.bombono.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ symphorien ];
  };
}
