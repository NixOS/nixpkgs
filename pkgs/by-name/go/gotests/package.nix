{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gotests";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "cweill";
    repo = "gotests";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-S7/m+D2jpKQHh07Xdq/0itccGHGNZQr2O1aWpaXCw/Y=";
  };

  vendorHash = "sha256-eflitwlIWcyR6vBna3YjHpeNjGMbFJJjXpk9NXuR2+I=";

  # tests are broken in nix environment
  doCheck = false;

  meta = {
    description = "Generate Go tests from your source code";
    mainProgram = "gotests";
    homepage = "https://github.com/cweill/gotests";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
})
