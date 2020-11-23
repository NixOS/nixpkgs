{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "0xxg48f28ac7x6kap6w1hgsimdc604ivkck4dx7p5p7xd3s7gld5";
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
