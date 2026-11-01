{
  lib,
  stdenv,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nixosTests,
  withGoolm ? false,
}:

buildGoModule (finalAttrs: {
  pname = "mautrix-telegram";
  version = "26.10";
  tag = "v0.2610.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    inherit (finalAttrs) tag;
    hash = "sha256-2oHtqtpFhNr+v49nMSe33RGDj+MQV2D/+8JX+YYWi+0=";
  };

  vendorHash = "sha256-JbnlJnCtIKC3rpO2mBa7DvEFeWuq9tpvN9H+MoQ5VV0=";

  ldflags = [
    "-X"
    "main.Tag=${finalAttrs.tag}"
  ];

  buildInputs = (lib.optional (!withGoolm) olm) ++ [ stdenv.cc.cc.lib ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.mautrix-telegram = nixosTests.mautrix-telegram;
  };

  tags = lib.optional withGoolm "goolm";

  meta = {
    homepage = "https://github.com/mautrix/telegram";
    description = "Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bartoostveen
      nyanloutre
      nickcao
    ];
    mainProgram = "mautrix-telegram";
  };
})
