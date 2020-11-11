{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.78.1";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rzv6az7fb1xvjxxq31rs42waqpwvks4h03lzjxv0kj8i43z116k";
  };

  vendorSha256 = "06cw3qj57nhrxrbbxcyrqn53j6g11rd2q7bxw89fdn901mc26s03";

  doCheck = false;

  runVend = true;

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
