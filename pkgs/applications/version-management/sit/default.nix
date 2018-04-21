{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "sit-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sit-it";
    repo = "sit";
    rev = "v${version}";
    sha256 = "1si4fg02wxi35hpkr58na06h19yjw6qd9c5mbb9xfkkzgz5mnssj";
  };

  cargoSha256 = "083p7z7blj064840ddgnxvqjmih4bmy92clds3qgv5v7lh63wfmn";

  meta = with stdenv.lib; {
    description = "Serverless Information Tracker";
    homepage = http://sit-it.org/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
