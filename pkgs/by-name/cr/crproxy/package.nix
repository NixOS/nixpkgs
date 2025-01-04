{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crproxy";
  version = "0.12.4"; # stable

  src = fetchFromGitHub {
    owner = "DaoCloud";
    repo = "crproxy";
    rev = "v${version}";
    hash = "sha256-jWSp0NzeXQu38fAaZ8eTqVN+uvpn6v5xgoi3N5SCQoc=";
  };

  vendorHash = "sha256-R78GbtTWgizvMz3HE83ZYxAbZBvCTbsuKLvPBCB5sx4=";

  env.CGO_ENABLED = 0;

  doCheck = true;

  meta = {
    description = "Generic Docker image proxy";
    homepage = "https://github.com/DaoCloud/crproxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SenseT ];
  };
}
