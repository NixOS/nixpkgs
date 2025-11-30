{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-8AffU5u7Pw3WX+MaLioPKVwg3WnTLjHcY6Yvo5lrHwk=";
  };

  vendorHash = "sha256-TsL7iYZoxCGR2gl2YlNCnmssVui8TLKN8JTtLAzgvH4=";

  meta = with lib; {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
