{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sachet";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "messagebird";
    repo = "sachet";
    tag = version;
    hash = "sha256-zcFViE1/B+wrkxZ3YIyfy2IBbxLvXOf8iK/6eqZb1ZQ=";
  };

  vendorHash = null;

  meta = {
    description = "SMS alerting tool for Prometheus's Alertmanager";
    mainProgram = "sachet";
    homepage = "https://github.com/messagebird/sachet";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ govanify ];
  };
}
