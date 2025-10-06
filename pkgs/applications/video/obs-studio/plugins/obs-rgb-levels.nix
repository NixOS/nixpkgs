{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-rgb-levels";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "wimpysworld";
    repo = "obs-rgb-levels";
    rev = version;
    sha256 = "sha256-DXrDyIBe2tp+9M39PLDf/AmX7lBa2teduBC8FG0IK7Y=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  meta = with lib; {
    description = "Simple OBS Studio filter to adjust RGB levels";
    homepage = "https://github.com/wimpysworld/obs-rgb-levels";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
