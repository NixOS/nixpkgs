{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libGL,
  pkg-config,
  xorg,
  mesa,
  libsndfile,
  libsamplerate,
}:

stdenv.mkDerivation rec {
  pname = "ninjas2";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "clearly-broken-software";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kwp6pmnfar2ip9693gprfbcfscklgri1k1ycimxzlqr61nkd2k9";
    fetchSubmodules = true;
  };

  patchPhase = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    xorg.libX11
    libGL
    mesa
    libsndfile
    libsamplerate
  ];

  installPhase = ''
    install -dD bin/ninjas2.lv2 $out/lib/lv2/ninjas2.lv2
    install -D bin/ninjas2-vst.so  $out/lib/vst/ninjas2-vst.so
    install -D bin/ninjas2 $out/bin/ninjas2
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/clearly-broken-software/ninjas2";
    description = "sample slicer plugin for LV2, VST, and jack standalone";
    license = with licenses; [ gpl3 ];
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "ninjas2";
  };
}
