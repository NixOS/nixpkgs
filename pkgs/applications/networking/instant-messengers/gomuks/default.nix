{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomuks";
  version = "2020-02-19";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "702592bf89dfcf1ec382c0a09d99318bce7a3943";
    sha256 = "0g638q8ypkp6dbfy1s4hz798cpkld301f914il3yd70yf05vvysc";
  };

  modSha256 = "03vbrh50pvx71rp6c23qc2sh0ir4jm1wl0gvi3z1c14ndzhsqky4";

  meta = with stdenv.lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner emily ];
    platforms = platforms.unix;
  };
}
