{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "0.7.11";
  name = "gitlab-workhorse-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "1z32nf9qbw050wzl1dsydrs68c9fp5kkvdn58z2g88bbyk6gyivm";
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

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
