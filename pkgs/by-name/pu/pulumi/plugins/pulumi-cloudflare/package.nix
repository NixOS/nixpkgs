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
  pulumi-cloudflare,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-cloudflare";
  version = "5.49.1";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-cloudflare";
    tag = "v${version}";
    hash = "sha256-KFkpweFNpS3iVmEqtNqTbW1Pg1r9geo+OFUwuFUiaeA=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-8uqmWjoiHuaYFwYkS6yx4rWp1SXY2xn/Mdu2TLsElJw=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-cloudflare/provider/v5/pkg/version.Version=${version}"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-cloudflare"
  ];

  checkFlags = [
    # Skip integration tests.
    "-short"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-cloudflare";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      postPatch
      ;
    subPackages = [
      "cmd/pulumi-tfgen-cloudflare"
      "cmd/pulumi-resource-cloudflare/generate.go"
    ];
  };

  postPatch = ''
    pushd ..
    chmod -R +w upstream
    for patch in patches/*.patch; do
      echo "Applying $patch"
      patch -p1 -d upstream <"$patch"
    done
    popd
  '';

  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-tfgen-cloudflare schema --out provider/cmd/pulumi-resource-cloudflare
    popd
    pushd cmd/pulumi-resource-cloudflare
    VERSION=$version "$codegen"/bin/generate
    popd
  '';

  postInstall = ''
    pushd ..
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-cloudflare "$lang" --out "$sdk/$lang"
    done
    popd
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-cloudflare;
  };

  passthru.sdks.python = python3Packages.pulumi-cloudflare;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulumi package for creating and managing Cloudflare cloud resources";
    mainProgram = "pulumi-resource-cloudflare";
    homepage = "https://github.com/pulumi/pulumi-cloudflare";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
