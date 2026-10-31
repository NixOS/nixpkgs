{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ntlhrQ0TEUX9eMxi3u6hDTOsjMCxRdGPtSY7lKnd66k=";
  };

  cargoHash = "sha256-csabVe4KvIyI7fHYVN/IgfC4KFsMmGjDTJR0tCSuSoQ=";

  # The tests require contacting external servers.
  doCheck = false;

  meta = {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "sendme";
  };
})
