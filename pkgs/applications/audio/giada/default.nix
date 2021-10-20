{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, fltk
, jansson
, rtmidi
, libsamplerate
, libsndfile
, jack2
, alsa-lib
, libpulseaudio
, libXpm
, libXinerama
, libXcursor
, catch2
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "giada";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qyx0bvivlvly0vj5nnnbiks22xh13sqlw4mfgplq2lbbpgisigp";
  };

  configureFlags = [
    "--target=linux"
    "--enable-system-catch"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    fltk
    libsndfile
    libsamplerate
    jansson
    rtmidi
    libXpm
    jack2
    alsa-lib
    libpulseaudio
    libXinerama
    libXcursor
    catch2
    nlohmann_json
  ];

  postPatch = ''
    sed -i 's:"deps/json/single_include/nlohmann/json\.hpp":<nlohmann/json.hpp>:' \
        src/core/{conf,init,midiMapConf,patch}.cpp
  '';

  meta = with lib; {
    description = "A free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    homepage = "https://giadamusic.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isAarch64; # produces build failure on aarch64-linux
  };
}
