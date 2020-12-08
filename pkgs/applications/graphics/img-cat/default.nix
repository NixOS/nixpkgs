{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "imgcat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trashhalo";
    repo = "imgcat";
    rev = "v${version}";
    sha256 = "0x7a1izsbrbfph7wa9ny9r4a8lp6z15qpb6jf8wsxshiwnkjyrig";
  };

  vendorSha256 = "191gi4c5jk8p9xvbm1cdhk5yi8q2cp2jvjq1sgxqw1ad0lppwhg2";

  meta = with lib; {
    description = "A tool to output images as RGB ANSI graphics on the terminal";
    homepage = "https://github.com/trashhalo/imgcat";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
