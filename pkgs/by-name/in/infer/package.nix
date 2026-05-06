{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  swift,
  apple-sdk,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "infer";
  version = "0.105.0";

  src = fetchFromGitHub {
    owner = "inference-gateway";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wb1D1ye2urAE31IrS5m/CvOT7VmkfRbJZVrqCmui0bg=";
  };

  vendorHash = "sha256-bsJ61iCA7N9YMx0L9URbb6sq/n1+U91VVs+oNkoxopA=";

  # Use the Go module proxy layout instead of `go mod vendor`. The robotgo
  # dependency includes CGO `#include` directives that reference C headers
  # in subpackages (e.g. screen/goScreen.h) that `go mod vendor` strips
  # because no Go code imports those subpackages directly. proxyVendor
  # preserves the full module layout, including the headers CGO needs.
  proxyVendor = true;

  # macOS requires CGO for clipboard support (golang.design/x/clipboard).
  env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/inference-gateway/cli/cmd.version=${finalAttrs.version}"
    "-X=github.com/inference-gateway/cli/cmd.commit=v${finalAttrs.version}"
  ];

  # Disable tests that require network or external dependencies
  preCheck = ''
    export HOME=$TMPDIR
  '';

  # Some tests may fail in the Nix sandbox due to networking requirements
  checkFlags = [
    "-skip=TestIntegration"
  ];

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ swift ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ];

  # On macOS, the Go binary embeds a SwiftUI floating-window helper app via
  # //go:embed. The build/ folder is gitignored, so we compile the Swift
  # sources before `go build` runs. The same build.sh is used by the
  # standard release workflow, keeping a single source of truth for the
  # Swift app build. build.sh reads SDKROOT and skips codesign when it is
  # not available in the sandbox.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export SDKROOT="${apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    pushd internal/display/macos/ComputerUse > /dev/null
    bash ./build.sh
    popd > /dev/null
  '';

  postInstall = ''
    # Rename binary from 'cli' to 'infer' if needed
    if [ -f $out/bin/cli ]; then
      mv $out/bin/cli $out/bin/infer
    fi

    # Generate shell completions
    installShellCompletion --cmd infer \
      --bash <($out/bin/infer completion bash) \
      --fish <($out/bin/infer completion fish) \
      --zsh <($out/bin/infer completion zsh)
  '';

  meta = {
    description = "Command-line interface for the Inference Gateway - AI model interaction manager";
    longDescription = ''
      The Inference Gateway CLI is a command-line tool for managing AI model interactions.
      It provides interactive chat, autonomous agent execution, and extensive tool
      integration for LLMs, with support for both the MCP and A2A protocols, as well
      as computer use for GUI automation. It can also run as a Telegram bot for
      remote-controlling the agent from chat.
    '';
    homepage = "https://github.com/inference-gateway/cli";
    changelog = "https://github.com/inference-gateway/cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edenreich ];
    mainProgram = "infer";
    platforms = lib.platforms.unix;
  };
})
