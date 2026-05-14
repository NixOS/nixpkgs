{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libGL,
  pkg-config,
  libx11,
  libsndfile,
  libsamplerate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ninjas2";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "clearly-broken-software";
    repo = "ninjas2";
    tag = "v${finalAttrs.version}";
    sha256 = "1kwp6pmnfar2ip9693gprfbcfscklgri1k1ycimxzlqr61nkd2k9";
    fetchSubmodules = true;
  };

  patchPhase = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    libx11
    libGL
    libsndfile
    libsamplerate
  ];

  installPhase = ''
    install -dD bin/ninjas2.lv2 $out/lib/lv2/ninjas2.lv2
    install -D bin/ninjas2-vst.so  $out/lib/vst/ninjas2-vst.so
    install -D bin/ninjas2 $out/bin/ninjas2
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/clearly-broken-software/ninjas2";
    description = "Sample slicer plugin for LV2, VST, and jack standalone";
    license = with lib.licenses; [ gpl3 ];
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "ninjas2";
  };
})
