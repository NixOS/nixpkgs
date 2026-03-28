{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-stroke-glow-shadow";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-stroke-glow-shadow";
    tag = "v${version}";
    sha256 = "sha256-PbN6Wdb6MzPe5918Y31UuYY49yuJp4W/2kfAOVJTMdo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postFixup = ''
    rm -rf $out/obs-plugins
    rm -rf $out/data
  '';

  meta = {
    description = "OBS plugin to provide efficient Stroke, Glow, and Shadow effects on masked sources";
    homepage = "https://github.com/FiniteSingularity/obs-stroke-glow-shadow";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
