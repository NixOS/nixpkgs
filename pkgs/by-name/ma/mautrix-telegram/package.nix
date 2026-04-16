{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  olm,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-telegram";
  version = "26.04";
  tag = "v0.2604.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    inherit tag;
    hash = "sha256-i/eIvsqLAst9nuhZL4a+SlMcqtwy8c0iWHwe+5dYVlI=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-mQ6zvEK6YcR71zLGD1n9xZzXqiXtKIs43rxeP278Ln0=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

  passthru.updateScript = nix-update-script { };

  # Some tests were failing, should be enabled in the future
  doCheck = false;

  meta = {
    homepage = "https://github.com/mautrix/telegram";
    description = "Matrix-Telegram puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nyanloutre
      nickcao
    ];
    mainProgram = "mautrix-telegram";
  };
}
