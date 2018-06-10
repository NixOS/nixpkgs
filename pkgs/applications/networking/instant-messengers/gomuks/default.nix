{ stdenv, buildGo110Package, fetchFromGitHub }:

buildGo110Package rec {
  name = "gomuks-${version}";
  version = "2018-05-16";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "gomuks";
    rev = "512ca88804268bf58a754e8a02be556f953db317";
    sha256 = "1bpgjkpvqqks3ljw9s0hm5pgscjs4rjy8rfpl2444m4rbpz1xvmr";
  };

  meta = with stdenv.lib; {
    homepage = https://maunium.net/go/gomuks/;
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner ];
    platforms = platforms.unix;
  };
}
