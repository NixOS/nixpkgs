{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "1ymixbix9sxhzmixqm9yjm9181aqnwnllqnswr0fq0nljw4018dn";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}