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
  version = "0.2.3";
in
buildGoModule {
  pname = "mautrix-slack";
  inherit version;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    tag = "v${version}";
    hash = "sha256-gR5D2uCNS+LiP0KXup/iIiOThWohzeBe4CD/oWak1BM=";
  };

  vendorHash = "sha256-aukL6RThtWcznz/x25btTTvloYkRZ/vhAQj1hOdI1U4=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
