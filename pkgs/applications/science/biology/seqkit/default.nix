{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-aS8aTh8Lszob9It89shhKyqxCDjFs7zxE3VhMCHYaGM=";
  };

  vendorHash = "sha256-54kb9Na76+CgW61SnXu7EfO0InH/rjliNRcH2M/gxII=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
