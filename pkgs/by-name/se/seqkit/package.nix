{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-rWmz9dPGCLY2d7aifRrz/GDiFTcc49+eB1xJLxs+Fyc=";
  };

  vendorHash = "sha256-v8aAY6MQS8jsyd7eVm5liAG5ChPELNKu4b8U/3y6bL4=";

  meta = with lib; {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
