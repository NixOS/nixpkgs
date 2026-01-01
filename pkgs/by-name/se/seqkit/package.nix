{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "seqkit";
<<<<<<< HEAD
  version = "2.12.0";
=======
  version = "2.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-9+eu4M58nG/tOdEW7fO8f+dMJewMjQsWfzH/KpSBDB8=";
=======
    sha256 = "sha256-8AffU5u7Pw3WX+MaLioPKVwg3WnTLjHcY6Yvo5lrHwk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-TsL7iYZoxCGR2gl2YlNCnmssVui8TLKN8JTtLAzgvH4=";

<<<<<<< HEAD
  meta = {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bzizou ];
=======
  meta = with lib; {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
