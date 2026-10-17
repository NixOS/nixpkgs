{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sendme";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1YuiTYGdr1G66Id9nvFa7y3nVbYi/dINMCpBCAz80WU=";
  };

  cargoHash = "sha256-AJsqI4rUeM+Cs6lFmQRcPom5YZZQJ1eVORAkUru+Xrk=";

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
