{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, iw
}:
let
  pname = "netscanner";
  version = "0.4.4";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-RO0+Zz1sivIjD8OM4TBHR5geJw540MAJfXEl2yriH6o=";
  };

  cargoHash = "sha256-GJLrUF2YAMtCtXTPJvlUURfiTYBFUE6Gmeux+5RXqAM=";

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
