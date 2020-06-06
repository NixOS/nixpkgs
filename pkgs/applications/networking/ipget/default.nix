{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipget";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    rev = "v${version}";
    sha256 = "14ygij6hj6bd4g4aw6jgfbi1fgpal0jgf1hr22zxm16dpx3vva6b";
  };

  vendorSha256 = "0vy21pdqk6q5fw7wlcv51myhh9y79n2qhvy61rmblwhxlrkh6sdv";

  meta = with stdenv.lib; {
    description = "Retrieve files over IPFS and save them locally";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
    platforms = platforms.unix;
  };
}
