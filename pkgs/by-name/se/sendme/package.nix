{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${version}";
    hash = "sha256-LcSQuvNXSHqaiBE6GR3rNALAYPc9Xezf5cV8Im9qYMo=";
  };

  cargoHash = "sha256-/hgkMWEokcOh3ebZ2pIunktJmuq0YpI6IixO7XoNRCk=";

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
}
