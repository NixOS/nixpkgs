{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  runCommand,
  fetchYarnDeps,
  nodejs,
  yarn,
  fixup-yarn-lock,
  pulumi-aws,
  # updateScript
  writers,
  nix,
  git,
  prefetch-yarn-deps,
}:
buildGoModule rec {
  pname = "pulumi-aws";
  version = "6.68.0";

  outputs = [
    "out"
    "sdk"
  ];

  src =
    let
      src = fetchFromGitHub {
        owner = "pulumi";
        repo = "pulumi-aws";
        tag = "v${version}";
        hash = "sha256-5eShdl5PMT8CKlOe4umXEFuCaivplqjbFYLZInY39CY=";
        fetchSubmodules = true;
      };
    in
    # https://github.com/pulumi/pulumi-aws/blob/5bffb1c5af97b8430288cc1bdc61a65bb7153dd2/Makefile#L274-L278
    # https://github.com/pulumi/pulumi-aws/blob/5bffb1c5af97b8430288cc1bdc61a65bb7153dd2/scripts/upstream.sh#L138-L150
    # https://github.com/pulumi/pulumi-aws/blob/5bffb1c5af97b8430288cc1bdc61a65bb7153dd2/upstream-tools/package.json#L11
    # NB the results of this script are needed for codegen to produce correct
    # output. This is a relatively expensive operation, so perform it in a
    # separate derivation that is shared between the main package and codegen.
    runCommand src.name
      {
        inherit src;
        strictDeps = true;
        nativeBuildInputs = [
          nodejs
          yarn
          fixup-yarn-lock
        ];
        yarnOfflineCache = fetchYarnDeps {
          yarnLock = "${src}/upstream-tools/yarn.lock";
          hash = "sha256-hSLBQFrH8pCO9ghpBI2KLHM5U8a3roL4oUEXoeToM8o=";
        };
      }
      ''
        cp -r -T --reflink=auto "$src" source
        chmod -R +w source

        cp -T source/upstream-tools/yarn.lock original-yarn.lock

        for patch in source/patches/*.patch; do
          echo "Applying $patch"
          patch -p1 -d source/upstream <"$patch"
        done

        export HOME=$PWD
        yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
        fixup-yarn-lock source/upstream-tools/yarn.lock
        yarn install \
          --cwd source/upstream-tools \
          --frozen-lockfile \
          --force \
          --production=false \
          --ignore-engines \
          --ignore-platform \
          --ignore-scripts \
          --no-progress \
          --non-interactive \
          --offline

        patchShebangs --build source/upstream-tools/node_modules

        for script in pre-replace strip-links global-replace; do
          yarn --offline --cwd source/upstream-tools run "$script"
        done

        rm -r source/upstream-tools/node_modules
        cp -T original-yarn.lock source/upstream-tools/yarn.lock
        mkdir -p "$out"
        cp -r -T --reflink=auto source "$out"
      '';

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-Yzu0tE7nd5vwtRc6hfcRkkoSomN3/+i34jPARWNfa2E=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-aws/provider/v6/pkg/version.Version=${version}"
    "-X=github.com/hashicorp/terraform-provider-aws/version.ProviderVersion=${version}"
  ];

  checkFlags = [
    "-skip=^TestUpstreamLint$"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-aws"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-aws";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [
      "cmd/pulumi-tfgen-aws"
      "cmd/pulumi-resource-aws/generate.go"
    ];
  };

  # https://github.com/pulumi/pulumi-aws/blob/5bffb1c5af97b8430288cc1bdc61a65bb7153dd2/Makefile#L262-L263
  # https://github.com/pulumi/pulumi-aws/blob/5bffb1c5af97b8430288cc1bdc61a65bb7153dd2/scripts/minimal_schema.sh#L7
  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-tfgen-aws schema --out provider/cmd/pulumi-resource-aws
    popd
    pushd cmd/pulumi-resource-aws
    VERSION=$version PULUMI_AWS_MINIMAL_SCHEMA= "$codegen"/bin/generate
    VERSION=$version PULUMI_AWS_MINIMAL_SCHEMA=true "$codegen"/bin/generate
    popd
  '';

  # https://github.com/pulumi/pulumi-aws/blob/5bffb1c5af97b8430288cc1bdc61a65bb7153dd2/provider/resources.go#L5286-L5402
  overlaidFiles = [
    "nodejs/arn.ts"
    "nodejs/region.ts"
    "nodejs/tags.ts"
    "nodejs/utils.ts"
    "nodejs/autoscaling/metrics.ts"
    "nodejs/autoscaling/notificationType.ts"
    "nodejs/alb/ipAddressType.ts"
    "nodejs/alb/loadBalancerType.ts"
    "nodejs/applicationloadbalancing/ipAddressType.ts"
    "nodejs/applicationloadbalancing/loadBalancerType.ts"
    "nodejs/cloudwatch/cloudwatchMixins.ts"
    "nodejs/cloudwatch/eventRuleMixins.ts"
    "nodejs/cloudwatch/logGroupMixins.ts"
    "nodejs/config/require.ts"
    "nodejs/dynamodb/dynamodbMixins.ts"
    "nodejs/ec2/instanceType.ts"
    "nodejs/ec2/instancePlatform.ts"
    "nodejs/ec2/placementStrategy.ts"
    "nodejs/ec2/protocolType.ts"
    "nodejs/ec2/tenancy.ts"
    "nodejs/ecr/lifecyclePolicyDocument.ts"
    "nodejs/ecs/container.ts"
    "nodejs/iam/documents.ts"
    "nodejs/iam/managedPolicies.ts"
    "nodejs/iam/principals.ts"
    "nodejs/kinesis/kinesisMixins.ts"
    "nodejs/lambda/runtimes.ts"
    "nodejs/lambda/lambdaMixins.ts"
    "nodejs/rds/engineMode.ts"
    "nodejs/rds/engineType.ts"
    "nodejs/rds/instanceType.ts"
    "nodejs/rds/storageType.ts"
    "nodejs/route53/recordType.ts"
    "nodejs/s3/cannedAcl.ts"
    "nodejs/s3/routingRules.ts"
    "nodejs/s3/s3Mixins.ts"
    "nodejs/sns/snsMixins.ts"
    "nodejs/sqs/redrive.ts"
    "nodejs/sqs/sqsMixins.ts"
    "nodejs/ssm/parameterType.ts"
  ];

  # buildGoModule breaks with structured attributes… :(
  postInstall = ''
    pushd ..
    if [[ -z $__structuredAttrs ]]; then
      overlaidFiles=($overlaidFiles)
    fi
    for f in "''${overlaidFiles[@]}"; do
      install -D -m 444 -t "$sdk/''${f%/*}" "sdk/$f"
    done
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-aws "$lang" --out "$sdk/$lang"
    done
    popd
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-aws;
  };

  passthru.sdks.python = python3Packages.pulumi-aws;

  passthru.updateScript = writers.writePython3 "pulumi-aws-updater" {
    libraries = with python3Packages; [ requests ];
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        nix
        git
        prefetch-yarn-deps
      ])
    ];
  } ./update.py;

  meta = {
    description = "Pulumi package for creating and managing Amazon Web Services (AWS) cloud resources";
    mainProgram = "pulumi-resource-aws";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
