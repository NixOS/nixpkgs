{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  olm,
  withGoolm ? false,
}:

buildGoModule (finalAttrs: {
  pname = "mautrix-telegram";
  version = "26.06";
  tag = "v0.2606.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    inherit (finalAttrs) tag;
    hash = "sha256-tKoqtGCkUtCT/SMxRX6LzivGu0p/AM6TPDQoW9plTyE=";
  };

  vendorHash = "sha256-+VDdJg5RZzMrphJ5SK+YbdENhPiHJpwGY/JqBJewtUo=";

  ldflags = [
    "-X"
    "main.Tag=v${finalAttrs.version}"
  ];

  buildInputs = (lib.optional (!withGoolm) olm) ++ [ stdenv.cc.cc.lib ];

  doCheck = false;

  tags = lib.optional withGoolm "goolm";

  meta = {
    homepage = "https://github.com/mautrix/telegram";
    description = "Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nyanloutre
      nickcao
    ];
    mainProgram = "mautrix-telegram";
  };
})
