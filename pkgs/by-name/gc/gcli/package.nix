{ lib
, fetchFromGitHub
, stdenv
, curl
, autoreconfHook
, pkg-config
, byacc
, flex
}:

stdenv.mkDerivation rec {
  pname = "gcli";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    rev = version;
    hash = "sha256-JZL0AcbrGYBceQ6ctspgnbzlVD4pg95deg9BWUFQCv8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config byacc flex ];
  buildInputs = [ curl ];

  meta = with lib; {
    description = "Portable Git(Hub|Lab|ea) CLI tool";
    homepage = "https://herrhotzenplotz.de/gcli/";
    changelog = "https://github.com/herrhotzenplotz/gcli/releases/tag/${version}";
    license = licenses.bsd2;
    mainProgram = "gcli";
    maintainers = with maintainers; [ kenran ];
  };
}
