{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.0.0+unstable=-2021-09-15";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "BQN";
    rev = "fb6ec1d8b083cd2b335828ae22e978b1b13986fa";
    hash = "sha256-57ryT5gb7hToAJOiGjjgU87rmlswjPK9tV1iQzJ4C0Y=";
  };

  postUnpack = ''
    sourceRoot="$sourceRoot/editors/emacs"
  '';

  meta = with lib; {
    homepage = "https://mlochbaum.github.io/BQN/editors/index.html";
    description = "Emacs mode for BQN";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.sternenseemann ];
  };
}
