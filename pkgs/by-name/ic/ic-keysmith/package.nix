{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "keysmith";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "dfinity";
    repo = "keysmith";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+wYWIoPYc7qpTRS4Zlxp50Up8obZOmfQpiT0SWwVJE0=";
  };

  vendorHash = "sha256-rIH10TRWOgmJM8bnKXYTsmmAtlrMMxHc8rnaCmMJGdw=";

  meta = {
    description = "Hierarchical Deterministic Key Derivation for the Internet Computer";
    homepage = "https://github.com/dfinity/keysmith";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "keysmith";
  };
})
