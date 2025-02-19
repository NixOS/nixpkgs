{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi-tls,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-tls";
  version = "5.1.0";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-tls";
    tag = "v${version}";
    hash = "sha256-f2XHVsGD/V68RF74yhF8uPkl4yfmZt+/91B/IQTyXKg=";
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-tQsI1vaoExsvZUSiR/yk97Yiq8zuhYja/I4hQKH7qio=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi-tls/provider/v5/pkg/version.Version=${version}"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-tls"
    "shim"
  ];

  checkFlags = [
    # Skip integration tests.
    # https://github.com/pulumi/pulumi-tls/blob/3ddc1ffb554d18524e3e8fe0784c36f08213f48e/provider/provider_program_test.go#L48
    "-short"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-tls";
    inherit
      src
      version
      sourceRoot
      vendorHash
      ldflags
      ;
    subPackages = [
      "cmd/pulumi-tfgen-tls"
      "cmd/pulumi-resource-tls/generate.go"
    ];
  };

  # https://github.com/pulumi/pulumi-tls/blob/3ddc1ffb554d18524e3e8fe0784c36f08213f48e/Makefile#L261
  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-tfgen-tls schema --out provider/cmd/pulumi-resource-tls
    popd
    pushd cmd/pulumi-resource-tls
    VERSION=$version "$codegen"/bin/generate
    popd
  '';

  postInstall = ''
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-tls "$lang" --out "$sdk/$lang"
    done
    cp -t "$sdk/python" ../README.md
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    package = pulumi-tls;
  };

  passthru.sdks.python = python3Packages.pulumi-tls;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulumi package to create TLS resources in Pulumi programs";
    mainProgram = "pulumi-resource-tls";
    homepage = "https://github.com/pulumi/pulumi-tls";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
