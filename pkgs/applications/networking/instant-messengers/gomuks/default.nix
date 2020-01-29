{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomuks";
  version = "2019-06-28";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "37df8eb454088e61db7a14f382851205bc1806ad";
    sha256 = "1hr15d9sbq6mddaxv3pwz86qp1hhzssgrvakfpc49xl4h04dq33g";
  };

  modSha256 = "1qrqgzzsxqvmy4m9shypa94bzw34mc941jhmyccip9grk9fzsxws";

  meta = with stdenv.lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner ];
    platforms = platforms.unix;
  };
}
