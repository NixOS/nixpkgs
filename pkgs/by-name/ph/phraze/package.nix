{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "phraze";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "sts10";
    repo = "phraze";
    rev = "v${version}";
    hash = "sha256-Kg3s5iNQajGFT1+YJFdCvq6UoFJS/YDfhdAOp6xV8w4=";
  };

  cargoHash = "sha256-3NmLvDNriXKBPsilK8x0gwzi3krIdVN5Bmi6ib3Dxe4=";

  meta = {
    description = "Generate random passphrases";
    homepage = "https://github.com/sts10/phraze";
    changelog = "https://github.com/sts10/phraze/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "phraze";
  };
}
