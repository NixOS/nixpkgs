{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "0nb0dm4yn6f5pw7clgb2d1khcwcxiidqyc0sdh38wwqg0zyil0cz";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}
