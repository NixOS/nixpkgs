{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-retro-effects";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-retro-effects";
    rev = "${version}";
    hash = "sha256-bqkviTA8ZjXU5d83/xxp6TNmiM/YuYImRTSneDo3SJ4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = {
    description = "Collection of OBS filters to give your stream that retro feel";
    homepage = "https://github.com/FiniteSingularity/obs-retro-effects";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
