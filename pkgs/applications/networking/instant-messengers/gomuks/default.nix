{ stdenv, buildGo110Package, fetchFromGitHub }:

buildGo110Package rec {
  name = "gomuks-${version}";
  version = "2018-07-10";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "gomuks";
    rev = "68db26bcace31297471641fe95f8882e301f5699";
    sha256 = "0dagdvsvn8nwqsvjbqk1c6gg2q1m40869nayrkwm3ndg2xkfdpm6";
  };

  meta = with stdenv.lib; {
    homepage = https://maunium.net/go/gomuks/;
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner ];
    platforms = platforms.unix;
  };
}
