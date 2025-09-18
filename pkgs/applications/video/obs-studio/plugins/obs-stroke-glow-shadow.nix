{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-stroke-glow-shadow";
  version = "v1.5.2";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-stroke-glow-shadow";
    rev = version;
    sha256 = "sha256-+2hb4u+6UG7IV9pAvPjp4wvDYhYnxe98U5QQjUcdD/k=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postFixup = ''
    rm -rf $out/obs-plugins
    rm -rf $out/data
  '';

  meta = with lib; {
    description = "OBS plugin to provide efficient Stroke, Glow, and Shadow effects on masked sources";
    homepage = "https://github.com/FiniteSingularity/obs-stroke-glow-shadow";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
