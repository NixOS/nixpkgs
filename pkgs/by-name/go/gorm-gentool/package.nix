{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gorm-gentool";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "go-gorm";
    repo = "gen";
    rev = "tools/gentool/v${version}";
    hash = "sha256-JOecNYEIL8vbc7znkKbaSrTkGyAva3ZzKzxducDtTx0=";
  };

  modRoot = "tools/gentool";

  proxyVendor = true;
  vendorHash = "sha256-8xUJcsZuZ1KpFDM1AMTRggl7A7C/YaXYDzRKNFKE+ww=";

  meta = with lib; {
    homepage = "https://github.com/go-gorm/gen";
    description = "Gen: Friendly & Safer GORM powered by Code Generation";
    license = licenses.mit;
    mainProgram = "gentool";
    maintainers = with maintainers; [ tembleking ];
  };
}
