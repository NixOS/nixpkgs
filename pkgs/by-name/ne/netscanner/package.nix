{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  iw,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netscanner";
  version = "0.6.43";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LLzv8+wAlZgXrj1Ldc+uGDfhvDYDtRU25R7UbmGb+ok=";
  };

  cargoHash = "sha256-47bvcj+0ZRcHjyt0cpZ0PT+NRvYdvBQcTTf9tZHci2Q=";

  postFixup = ''
    wrapProgram $out/bin/netscanner \
      --prefix PATH : "${lib.makeBinPath [ iw ]}"
  '';

  meta = {
    description = "Network scanner with features like WiFi scanning, packetdump and more";
    homepage = "https://github.com/Chleba/netscanner";
    changelog = "https://github.com/Chleba/netscanner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "netscanner";
  };
})
