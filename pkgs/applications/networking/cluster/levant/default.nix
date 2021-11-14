{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "levant";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "levant";
    rev = "v${version}";
    sha256 = "9M7a4i+DPKb1H9jOEVAvhvYxGwtj3dK/40n4GSy4Rqo=";
  };

  vendorSha256 = "5JlrgmIfhX0rPR72sUkFcofw/iIbIaca359GN9C9dhU=";

  runVend = true;

  # The tests try to connect to a Nomad cluster.
  doCheck = false;

  meta = with lib; {
    description = "An open source templating and deployment tool for HashiCorp Nomad jobs";
    homepage = "https://github.com/hashicorp/levant";
    license = licenses.mpl20;
    maintainers = with maintainers; [ max-niederman ];
    platforms = platforms.unix;
  };
}
