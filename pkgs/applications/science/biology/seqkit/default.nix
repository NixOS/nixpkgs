{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-JsrmRUbSNCFJ58tIblKq+VRXCD1mBeCAcosDGiVb5Gs=";
  };

  vendorHash = "sha256-0//kySYhNmfiwiys/Ku0/8RzKpnxO0+byD8pcIkvDY0=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
