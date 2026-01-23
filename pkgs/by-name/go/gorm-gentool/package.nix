{
  lib,
  # Build fails with Go 1.25, with the following error:
  # 'vendor/golang.org/x/tools/internal/tokeninternal/tokeninternal.go:64:9: invalid array length -delta * delta (constant -256 of type int64)'
  # Wait for upstream to update their vendored dependencies before unpinning.
  buildGo124Module,
  fetchFromGitHub,
}:
buildGo124Module rec {
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

  meta = {
    homepage = "https://github.com/go-gorm/gen";
    description = "Gen: Friendly & Safer GORM powered by Code Generation";
    license = lib.licenses.mit;
    mainProgram = "gentool";
    maintainers = with lib.maintainers; [ tembleking ];
  };
}
