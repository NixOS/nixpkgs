{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "hugo";
  version = "0.68.1";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h7zymvxk71jq51az4qnldk54jl9sd4zwkn5r5323xzjffwzny82";
  };

  modSha256 = "04vzm65kbj9905z4cf5yh6yc6g3b0pd5vc00lrxw84pwgqgc0ykb";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
