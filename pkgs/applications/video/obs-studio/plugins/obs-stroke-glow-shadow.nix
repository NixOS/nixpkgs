{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-stroke-glow-shadow";
  version = "v1.6.1";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-stroke-glow-shadow";
    rev = version;
    hash = "sha256-h0AYCN0BhOi2jtmFXAMdarl/D55I4sR/mlVip9NgeJ4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = {
    description = "OBS plugin to provide efficient Stroke, Glow, and Shadow effects on masked sources";
    homepage = "https://github.com/FiniteSingularity/obs-stroke-glow-shadow";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
