{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  versionCheckHook,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:
let
  version = "0.1.4";
in
buildGoModule {
  pname = "mautrix-slack";
  inherit version;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    tag = "v${version}";
    hash = "sha256-MDbWvbEY8+CrUL1SnjdJ4SqyOH/5gPsEQkLnTHyJdOo=";
  };

  vendorHash = "sha256-8U6ifMLRF7PJyG3hWKgBtj/noO/eCXXD60aeB4p2W54=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix-Slack puppeting bridge";
    homepage = "https://github.com/mautrix/slack";
    changelog = "https://github.com/mautrix/slack/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ BonusPlay ];
    mainProgram = "mautrix-slack";
  };
}
