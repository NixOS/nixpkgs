{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, libjack2
, cmake
, lv2
, pkg-config
, tree
}:

stdenv.mkDerivation rec {
  pname = "audio-bridge";
  version = "2023-08-22";

  src = fetchFromGitHub {
    owner = "falkTX";
    repo = pname;
    rev = "b85ef510dfca27e48fb7c86030b0ad854aaf63f3";
    hash = "sha256-mVIJT7v85JM6qJVBwdAWINlX1kOYJfos03mf+W7qipY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config tree];
  buildInputs = [ alsa-lib libjack2 lv2 cmake ];

  installPhase = ''
  mkdir -p "$out"/{bin,lib/lv2}
  cp -r audio-bridge.lv2 "$out"/lib/lv2
  cp jack-audio-bridge "$out"/bin
  '';

  # enableParallelBuilding = true;

  meta = with lib; {
    description = "Connect additional ALSA devices to JACK";
    homepage = "https://github.com/falkTX/audio-bridge";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ PowerUser64 ];
    platforms = platforms.linux;
  };
}
