{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "1g1bh1v3yd3dz80ckjrhspmsf78nw8hc907hh9jzbq62psqg4459";
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
