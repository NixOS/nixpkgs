{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y7aaBm6KG+b8eEr2W8jmN2Ws3y0Dzkk848af3yse1/8=";
  };

  cargoHash = "sha256-J4ctZ1a7pSKVTi1BAHRZMNLrfrODWKDrgsBRZN/24DM=";

  # The tests require contacting external servers.
  doCheck = false;

  meta = {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
})
