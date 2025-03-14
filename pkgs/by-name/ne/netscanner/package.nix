{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  iw,
}:
let
  pname = "netscanner";
  version = "0.6.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    tag = "v${version}";
    hash = "sha256-/8UhnJ4ZPaJ+CQPCeKr1uH0Iw6A4/DARiSukK6+ZZeY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-i+btU1ovqPGzhXi8IPZonSAdlpcbMPrWSbL7COKou9M=";

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
