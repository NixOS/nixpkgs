{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-W272ymy56aHRSOmi/0nCaU+AeaC0U/RyxzHOKR9meo4=";
  };

  vendorHash = "sha256-mmefX3SpQoSdpuwoxFmlYocE9ETOHz3fh/IDG5LlY7E=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
