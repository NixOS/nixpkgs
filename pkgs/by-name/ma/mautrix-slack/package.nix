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
buildGoModule rec {
  pname = "mautrix-slack";
  version = "25.11";
  tag = "v0.2511.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    inherit tag;
    hash = "sha256-9f+GL0eziA2Z9qFXY9VRwj6PK0jUm4bo90pJEuNR1IY=";
  };

  vendorHash = "sha256-djNvUIlJuWqqREV3tYmEe9yolKymhuzA0jsp714qfOQ=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

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
