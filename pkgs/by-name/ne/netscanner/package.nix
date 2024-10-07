{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, iw
}:
let
  pname = "netscanner";
  version = "0.5.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-rqUGi7UF9y3VZ0KoctCesQVgJbR1WfqhFA6aYFFimNk=";
  };

  cargoHash = "sha256-VP6L3lXDXadimSWC2L4yfzTRfTcUilJtZ7TeHARAKAY=";

  postFixup = ''
    wrapProgram $out/bin/netscanner \
      --prefix PATH : "${lib.makeBinPath [iw]}"
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
