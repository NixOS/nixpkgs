{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.4.22";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "go-ipfs";
    inherit rev;
    sha256 = "1drwkam2m1qdny51l7ja9vd33jffy8w0z0wbp28ajx4glp0kyra2";
  };

  modSha256 = "0jbzkifn88myk2vpd390clyl835978vpcfz912y8cnl26s6q677n";

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
