{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-noise";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-noise";
    rev = "v${version}";
    hash = "sha256-koU3xqGZ3gWBGd+EMDG/GkarSB9rZibFasprMSqVFg8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = {
    description = "Plug-in for noise generation and noise effects for OBS";
    homepage = "https://github.com/FiniteSingularity/obs-noise";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
