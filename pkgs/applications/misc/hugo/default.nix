{ stdenv, buildGoModule, fetchFromGitHub, libsass }:

buildGoModule rec {
  pname = "hugo";
  version = "0.73.0";

  buildInputs = [ libsass ];

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qhv8kdv5k1xfk6106lxvsz7f92k7w6wk05ngz7qxbkb6zkcnshw";
  };

  modvendorCopy = true;
  vendorSha256 = "0ypgjn9lkdj48s3cbmaimh0l7md18kkxn6j4zrl5riah9a0bmghg";

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
