{ stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "terraform-provider-keycloak";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "mrparkers";
    repo = "terraform-provider-keycloak";
    rev = version;
    sha256 = "1h8780k8345pf0s14k1pmwdjbv2j08h4rq3jwds81mmv6qgj1r2n";
  };

  vendorSha256 = "12iary7p5qsbl4xdhfd1wh92mvf2fiylnb3m1d3m7cdcn32rfimq";

  doCheck = false;

  postInstall = "mv $out/bin/terraform-provider-keycloak{,_v${version}}";

  meta = with stdenv.lib; {
    description = "Terraform provider for keycloak";
    homepage = "https://github.com/mrparkers/terraform-provider-keycloak";
    license = licenses.mpl20;
    maintainers = with maintainers; [ eonpatapon ];
  };

}
