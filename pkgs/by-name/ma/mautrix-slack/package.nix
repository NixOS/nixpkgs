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
  version = "26.09.1";
  tag = "v0.2609.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    inherit tag;
    hash = "sha256-zaAuRPgrTTdT/nEGN3ULsBqpFPE7iJKFYOB20mXqXUs=";
  };

  vendorHash = "sha256-HgS1dLhMui1Eq4K0KIMajq3cVrNj0Pq4ss6cSRE9V7E=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  # These tests call slackBlocksToMatrix with a context that has no user login,
  # but GetMentionedMessageURL unconditionally type-asserts it from the context.
  # Upstream's CI never runs `go test`, so the test remains broken.
  # https://github.com/mautrix/slack/blob/v0.2609.1/pkg/msgconv/blocks_test.go#L98
  checkFlags = [ "-skip=TestSlackBlocksToMatrixMessageMention" ];

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
    changelog = "https://github.com/mautrix/slack/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ BonusPlay ];
    mainProgram = "mautrix-slack";
  };
}
