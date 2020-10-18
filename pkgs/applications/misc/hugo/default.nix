{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.76.5";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p7zz9cif1vihhs21nvh4n3y1p2cwpga59rilpam7yvza4nzx7ay";
  };

  vendorSha256 = "0kiqy8n2df52gsgsbmr96rph8lpnw06g622123hlwk7kqg0z9ifh";

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
