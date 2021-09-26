{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.0.0+unstable=2021-09-26";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "BQN";
    rev = "97cbdc67fe6a9652c42daefadd658cc41c1e5ae3";
    sha256 = "09nmsl7gzyi56g0x459a6571c8nsafl0g350m0hk1vy2gpg6yq0p";
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
