{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi,
  pulumi-go,
  pulumi-nodejs,
  pulumi-python,
  pulumi-command,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-command";
  version = "1.1.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-command";
    tag = "v${version}";
    hash = "sha256-C0vP3WPj47JKUWlmWmtNLM/GvxGgNv/uZOFdPUcTE2Y=";
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-iixwcsXCiAqef7gx8sUJD7Rmn1GTgHSry0+1PHbtp8M=";

  nativeBuildInputs = [
    pulumi
    pulumi-go
    pulumi-nodejs
    pulumi-python
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-command/provider/pkg/version.Version=${version}"
  ];

  excludedPackages = [
    # Contains go.mod so buildGoModule gets confused.
    "tests"
  ];

  checkFlags = [
    "-skip=^TestUpgradeLocalCommand$"
  ];

  codegen = buildPackages.buildGoModule {
    inherit
      src
      pname
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [ "cmd/pulumi-resource-command" ];
  };

  # https://github.com/pulumi/pulumi-command/blob/9c225f24a5d876fc86e5ae48fb01769ca32edd99/Makefile#L42-L43
  postConfigure = ''
    pulumi package get-schema "$codegen/bin/pulumi-resource-command" \
      >cmd/pulumi-resource-command/schema.json
  '';

  postInstall = ''
    for lang in go nodejs python; do
      pulumi package gen-sdk cmd/pulumi-resource-command/schema.json \
        --language "$lang" --version "$version" --out "$sdk"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;
  __impureHostDeps = lib.optional stdenv.buildPlatform.isDarwin "/dev/stderr";

  passthru.tests.schema = testResourceSchema {
    package = pulumi-command;
  };

  passthru.sdks.python = python3Packages.pulumi-command;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v(.*)" ];
  };

  meta = {
    description = "Pulumi provider to execute commands and scripts either locally or remotely as part of the Pulumi resource model";
    mainProgram = "pulumi-resource-command";
    homepage = "https://github.com/pulumi/pulumi-command";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      trundle
      tie
    ];
  };
}
