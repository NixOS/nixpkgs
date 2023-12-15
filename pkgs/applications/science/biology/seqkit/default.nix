{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-ahCLPYRRH6xIRFhgpjvnw7G1AIOfrkzLKPA8t9+k9gg=";
  };

  vendorHash = "sha256-OpLLJdwEW7UnMKr6r8+EDUlpiahfa5k9AkBqcd+SE5k=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
