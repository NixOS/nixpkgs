{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  iw,
}:
let
  pname = "netscanner";
  version = "0.5.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-iRVmazOiUvpl29A0Ju0e2mzFRJtQD7ViY22Jai005nY=";
  };

  cargoHash = "sha256-oH+rU8IZwC8aZ320bIehddPq/+9IYQs+AlZe94LHNYk=";

  postFixup = ''
    wrapProgram $out/bin/netscanner \
      --prefix PATH : "${lib.makeBinPath [ iw ]}"
  '';

  meta = {
    description = "Network scanner with features like WiFi scanning, packetdump and more";
    homepage = "https://github.com/Chleba/netscanner";
    changelog = "https://github.com/Chleba/netscanner/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "netscanner";
  };
}
