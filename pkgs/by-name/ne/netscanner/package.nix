{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, iw
}:
let
  pname = "netscanner";
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-xdY3moWRmSMZ3PVyuHBnp8c9k5KxH+MoE5+s0QWSUM4=";
  };

  cargoHash = "sha256-15BNkrr79KMyFcn7NJrGCj25RjH/a4WUOQAoMPzJieQ=";

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
