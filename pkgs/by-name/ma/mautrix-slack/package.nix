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
  version = "26.02";
  tag = "v0.2602.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    inherit tag;
    hash = "sha256-Xb3Jfw/hvIKeKUsYDOjxcNXTgLkItuGFV8jAfMT+Ai8=";
  };

  vendorHash = "sha256-XpR2AbYRbMRQSn/NrNMH/ik2gAYbxhUZb8jWJdUoEjY=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  nativeInstallCheckInputs = [ versionCheckHook ];
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
