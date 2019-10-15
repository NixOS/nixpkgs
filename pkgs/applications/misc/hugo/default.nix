{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.58.3";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "00dhb6xilkwr9yhncpyc6alzqw77ch3vd85dc7lzsmhw1c80n0lc";
  };

  modSha256 = "0d6zc7hxb246zsvwsjz4ds6gdd2m95x6l3djh3mmciwfg9cd7prx";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux ];
  };
}
