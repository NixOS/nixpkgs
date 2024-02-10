{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-tnVkFING9BH/iNOdKeCsSk4ln2fLUUpI5ASaQ7CCdrg=";
  };

  vendorHash = "sha256-o7XGBI05BK7kOBagVV2eteJmkzLTmio41KOm46GdzDU=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
