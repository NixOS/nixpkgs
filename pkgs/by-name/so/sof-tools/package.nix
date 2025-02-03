{ lib, stdenv, fetchFromGitHub, cmake, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "sof-tools";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof";
    rev = "v${version}";
    hash = "sha256-AOBJtC40Lu1gWM8w/Vs/nc540bisg58m+qH16F1e6jY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ alsa-lib ];
  sourceRoot = "${src.name}/tools";

  meta = with lib; {
    description = "Tools to develop, test and debug SoF (Sund Open Firmware)";
    homepage = "https://thesofproject.github.io";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.johnazoidberg ];
    mainProgram = "sof-ctl";
  };
}
