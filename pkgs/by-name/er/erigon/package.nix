{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "erigon";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "erigontech";
    repo = "erigon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-54ME/ssXM/wi8UQu08q0phDq9n2/wozKV7qgVHozuT8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-kedZWMfpI33SQQvfv+HsonxkD9OBKqG1vtCDQec1Crg=";
  proxyVendor = true;

  subPackages = [
    "cmd/erigon"
    "cmd/evm"
    "cmd/rpcdaemon"
    "cmd/rlpdump"
  ];

  # Matches the tags to upstream's release build configuration
  # https://github.com/erigontech/erigon/blob/0a263a3d989f79310d78c3d42c27beef01d5dcb5/wmake.ps1#L415
  tags = [
    "nosqlite"
    "noboltdb"

    # Enabling silkworm also breaks the build as it requires dynamically linked libraries:
    # > Some binaries contain forbidden references to /build/.
    #
    # If we need it in the future, we should consider packaging silkworm and silkworm-go
    # as dependencies explicitly.
    "nosilkworm"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # avoid testing‐releases; erigon tags are v-prefixed
      "--version-regex"
      "^v?(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/erigon";

  meta = {
    homepage = "https://github.com/erigontech/erigon/";
    description = "Erigon is an implementation of Ethereum (execution layer with embeddable consensus layer), on the efficiency frontier.";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [
      happysalada
      pmw
    ];
  };
})
