{ stdenv, lib, fetchFromGitHub, isabelle }:

stdenv.mkDerivation rec {
  pname = "isabelle-linter";
  version = "Isabelle2021-1-v1.0.0";

  src = fetchFromGitHub {
    owner = "isabelle-prover";
    repo = "isabelle-linter";
    rev = version;
    sha256 = "0v6scc2rhj6bjv530gzz6i57czzcgpkw7a9iqnfdnm5gvs5qjk7a";
  };

  installPhase = import ./mkBuild.nix { inherit isabelle; path = "${pname}-${version}"; };

  meta = with lib; {
    description = "Linter component for Isabelle.";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with maintainers; [ jvanbruegge ];
    license = licenses.mit;
  };
}
