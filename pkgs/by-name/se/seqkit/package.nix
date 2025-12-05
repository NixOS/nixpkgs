{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-9+eu4M58nG/tOdEW7fO8f+dMJewMjQsWfzH/KpSBDB8=";
  };

  vendorHash = "sha256-TsL7iYZoxCGR2gl2YlNCnmssVui8TLKN8JTtLAzgvH4=";

  meta = with lib; {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
