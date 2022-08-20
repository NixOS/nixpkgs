{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, codec2
, libpulseaudio
, libsamplerate
, libsndfile
, lpcnetfreedv
, portaudio
, speexdsp
, hamlib
, wxGTK31-gtk3
, pulseSupport ? config.pulseaudio or stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "freedv";
  version = "1.8.3.1";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    rev = "v${version}";
    hash = "sha256-LPCY5gPinxJkfPfumKggI/JQorcW+Qw/ZAP6XQmPkeA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    codec2
    libsamplerate
    libsndfile
    lpcnetfreedv
    speexdsp
    hamlib
    wxGTK31-gtk3
  ] ++ (if pulseSupport then [ libpulseaudio ] else [ portaudio ]);

  cmakeFlags = [
    "-DUSE_INTERNAL_CODEC2:BOOL=FALSE"
    "-DUSE_STATIC_DEPS:BOOL=FALSE"
  ] ++ lib.optionals pulseSupport [ "-DUSE_PULSEAUDIO:BOOL=TRUE" ];

  meta = with lib; {
    homepage = "https://freedv.org/";
    description = "Digital voice for HF radio";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mvs ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;  # see https://github.com/NixOS/nixpkgs/issues/165422
  };
}
