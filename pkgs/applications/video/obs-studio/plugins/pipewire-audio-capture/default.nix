{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, obs-studio
, pipewire
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "obs-pipewire-audio-capture";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = pname;
    rev = "${version}";
    sha256 = "OX27NTUsceEC8kHqlM+oeGjPxguake6lwaXFYsoEqKU=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ obs-studio pipewire ];

  meta = with lib; {
    description = " Audio device and application capture for OBS Studio using PipeWire ";
    homepage = "https://github.com/dimtpap/obs-pipewire-audio-capture";
    maintainers = with maintainers; [ Elinvention ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
