{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-v2Z94UDuXnT7eVFX+uLSxXR34eIBzRm1bHwD7gO9SVA=";
  };

  vendorHash = "sha256-dDMSwZnTWC60zvPDvUT+9T/mUUrhW0Itn87XO/+Ef2Q=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
