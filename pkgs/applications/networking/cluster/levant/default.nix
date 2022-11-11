{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "levant";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "levant";
    rev = "v${version}";
    sha256 = "sha256-ujybD4nSHC/w2Pfu43eSO6rNJjXFAvc81T05icWFvbs=";
  };

  vendorSha256 = "sha256-pKxj0qz7adSuPpiXu4+2KBO3JZu8zZ8ycPF5LosF4T8=";

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
