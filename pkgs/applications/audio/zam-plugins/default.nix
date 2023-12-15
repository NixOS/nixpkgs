{ lib, stdenv, fetchFromGitHub, boost, libX11, libGL, liblo, libjack2, ladspaH, lv2, pkg-config, rubberband, libsndfile, fftwFloat, libsamplerate }:

stdenv.mkDerivation rec {
  pname = "zam-plugins";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "zamaudio";
    repo = pname;
    rev = version;
    sha256 = "sha256-6TPZMDhGHqXjY8UYEqlr4hweF+W19IpIfSa9Bo9Ta1A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ boost libX11 libGL liblo libjack2 ladspaH lv2 rubberband libsndfile fftwFloat libsamplerate ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.zamaudio.com/?p=976";
    description = "A collection of LV2/LADSPA/VST/JACK audio plugins by ZamAudio";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
