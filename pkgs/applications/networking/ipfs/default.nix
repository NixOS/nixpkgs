{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.4.21";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/go-ipfs";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "0jlj89vjy4nw3x3j45r16y8bph5ss5lp907pjgqvad0naxbf99b0";
  };

  modSha256 = "0d9rq0hig9jwv9jfajfyj2111arikqzdnyhf5aqkwahcblpx54iy";

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
