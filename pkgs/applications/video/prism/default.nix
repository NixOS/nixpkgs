{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prism";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q7q7aj3fm45bnx6hgl9c1ll8na16x6p7qapr0c4a6dhxwd7n511";
  };

  vendorSha256 = "1mkd1s9zgzy9agy2rjjk8wfdga7nzv9cmwgiarfi4xrqzj4mbaxq";

  meta = with lib; {
    description = "An RTMP stream recaster/splitter";
    homepage = "https://github.com/muesli/prism";
    license = licenses.mit;
    maintainers = with maintainers; [ paperdigits ];
  };
}
