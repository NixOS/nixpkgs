{ stdenv, lib, fetchFromGitHub, isabelle }:

stdenv.mkDerivation rec {
  pname = "isabelle-linter";
  version = "unstable-2022-09-05";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = "0424fc05426d5f7a23adf19ad08c690c17184e86";
    sha256 = "02afbgmi195ibichjkpni2wjgjkszv7i6qkmmprwrmb4jd2wdvd5";
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
  };
}
