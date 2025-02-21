{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  callPackage,
  pulumi-postgresql,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-postgresql";
  version = "3.15.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-postgresql";
    tag = "v${version}";
    hash = "sha256-BkHQI1g2hM5Or2q1cF60IZCV8jePp9x43CSWoWTl2zI=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-ZvrSs8xgvwPQusdhvI6jZ+CpHEpROAh1YMyV5aDn09A=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-postgresql/provider/v3/pkg/version.Version=${version}"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-postgresql"
  ];

  checkFlags = [
    # Skip integration tests.
    "-short"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-postgresql";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      postPatch
      ;
    subPackages = [
      "cmd/pulumi-tfgen-postgresql"
      "cmd/pulumi-resource-postgresql/generate.go"
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
    "$codegen"/bin/pulumi-tfgen-postgresql schema --out provider/cmd/pulumi-resource-postgresql
    popd
    pushd cmd/pulumi-resource-postgresql
    VERSION=$version "$codegen"/bin/generate
    popd
  '';

  postInstall = ''
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-postgresql "$lang" --out "$sdk/$lang"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.smokeTest = callPackage ./smoke-test.nix { };

  passthru.tests.schema = testResourceSchema {
    package = pulumi-postgresql;
  };

  passthru.sdks.python = python3Packages.pulumi-postgresql;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulumi package for creating and managing PostgreSQL cloud resources";
    mainProgram = "pulumi-resource-postgresql";
    homepage = "https://github.com/pulumi/pulumi-postgresql";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
