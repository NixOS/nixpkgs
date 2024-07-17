{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  iw,
}:
let
  pname = "netscanner";
  version = "0.5.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-gVwI5dGQqSQf2wR7oKMTRIqseUbAEDTTuQ51S6dvEFw=";
  };

  cargoHash = "sha256-30VSeBbaVWVEO14eUx28HSymfkCxH0IZmEN4cnJ9wIk=";

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
