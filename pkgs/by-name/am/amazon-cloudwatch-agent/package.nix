{
  lib,
  amazon-cloudwatch-agent,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  stdenv,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "amazon-cloudwatch-agent";
  version = "1.300046.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-cloudwatch-agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-rBaRgr8CqNH3F/Qc2MlL7ij/WV7v+wXnPx+elsygRbE=";
  };

  vendorHash = "sha256-49TR5Hfi5o1EnJ5CErjFJEsmyzTFJ6E6zyYw4wPjDKY=";

  # See the list in https://github.com/aws/amazon-cloudwatch-agent/blob/v1.300046.2/Makefile#L68-L77.
  subPackages = [
    "cmd/config-downloader"
    "cmd/config-translator"
    "cmd/amazon-cloudwatch-agent"
    # Broken since it hardcodes the package install path. See https://github.com/aws/amazon-cloudwatch-agent/issues/1319.
    # "cmd/start-amazon-cloudwatch-agent"
    "cmd/amazon-cloudwatch-agent-config-wizard"
  ];

  # See https://github.com/aws/amazon-cloudwatch-agent/blob/v1.300046.2/Makefile#L57-L64.
  #
  # Needed for "amazon-cloudwatch-agent -version" to not show "Unknown".
  postInstall = ''
    mkdir --parents $out/bin

    cat > $out/bin/CWAGENT_VERSION << END_OF_FILE
    v${version}
    END_OF_FILE
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-version";

  passthru = {
    tests = lib.optionalAttrs stdenv.isLinux {
      inherit (nixosTests) amazon-cloudwatch-agent;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "CloudWatch Agent enables you to collect and export host-level metrics and logs on instances running Linux or Windows server.";
    homepage = "https://github.com/aws/amazon-cloudwatch-agent";
    license = lib.licenses.mit;
    mainProgram = "amazon-cloudwatch-agent";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pmw ];
  };
}
