{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "0.6.4";
  name = "gitlab-workhorse-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = version;
    sha256 = "09bs3kdmqi6avdak2nqma141y4fhfv050zwqqx7qh9a9hgkgwjxw";
  };

  buildInputs = [ git go ];

  patches = [ ./remove-hardcoded-paths.patch ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';
}
