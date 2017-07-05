{ stdenv, fetchFromGitLab, git, go }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "gitaly-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "0dydlq33ly2f2b3iyg967i2fq1alh6wa7hsq4nh7lmgy8v0w38ab";
  };

  buildInputs = [ git go ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ roblabla ];
    license = licenses.mit;
  };
}
