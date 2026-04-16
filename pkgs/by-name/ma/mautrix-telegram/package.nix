{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  olm,
  withGoOlm ? false,
}:

buildGoModule (finalAttrs: {
  pname = "mautrix-telegram";
  version = "0.2604.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i/eIvsqLAst9nuhZL4a+SlMcqtwy8c0iWHwe+5dYVlI=";
  };

  vendorHash = "sha256-mQ6zvEK6YcR71zLGD1n9xZzXqiXtKIs43rxeP278Ln0=";

  ldflags = [
    "-X"
    "main.Tag=v${finalAttrs.version}"
  ];

  buildInputs = (lib.optional (!withGoOlm) olm) ++ [ stdenv.cc.cc.lib ];

  doCheck = false;

  tags = lib.optional withGoOlm "goolm";

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
