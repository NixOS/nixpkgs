{ stdenv, lib, fetchFromGitHub, isabelle }:

stdenv.mkDerivation rec {
  pname = "isabelle-linter";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "Isabelle2022-v${version}";
    sha256 = "sha256-qlojNCsm3/49TtAVq6J31BbQipdIoDcn71pBotZyquY=";
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
    platforms = platforms.all;
  };
}
