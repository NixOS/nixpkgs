{ stdenv, lib, fetchFromGitHub, isabelle }:

stdenv.mkDerivation rec {
  pname = "isabelle-linter";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "unstable-2022-09-05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
<<<<<<< HEAD
    rev = "Isabelle2022-v${version}";
    sha256 = "sha256-qlojNCsm3/49TtAVq6J31BbQipdIoDcn71pBotZyquY=";
=======
    rev = "0424fc05426d5f7a23adf19ad08c690c17184e86";
    sha256 = "02afbgmi195ibichjkpni2wjgjkszv7i6qkmmprwrmb4jd2wdvd5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ isabelle ];

  buildPhase = ''
    export HOME=$TMP
    isabelle components -u $(pwd)
    isabelle scala_build
  '';

  installPhase = ''
    dir=$out/Isabelle${isabelle.version}/contrib/${pname}-${version}
    mkdir -p $dir
    cp -r * $dir/
  '';

  meta = with lib; {
    description = "Linter component for Isabelle.";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with maintainers; [ jvanbruegge ];
    license = licenses.mit;
<<<<<<< HEAD
    platforms = platforms.all;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
