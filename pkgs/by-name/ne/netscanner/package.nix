{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  iw,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netscanner";
  version = "0.6.41";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "Chleba";
    repo = "netscanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Srsts0FDLMT01YW5Guv3r8yx5i5ua7bhAFbQ5BMN74=";
  };

  cargoHash = "sha256-vlV5SibQlJ/yhJJKweqg6KYinpgZmWUUnyzAS6LBBKw=";

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
