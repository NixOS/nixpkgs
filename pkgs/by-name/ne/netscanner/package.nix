{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, iw
}:
let
  pname = "netscanner";
  version = "0.4.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-E9WQpWqXWIhY1cq/5hqBbNBffe/nFLBelnFPW0tS5Ng=";
  };

  cargoHash = "sha256-G2ePiVmHyZ7a4gn7ZGg5y4lhfbWoWGh4+fG9pMHZueg=";

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
