{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildPackages,
  python3Packages,
  testResourceSchema,
  pulumi-yandex-unofficial,
  nix-update-script,
}:
buildGoModule rec {
  pname = "pulumi-yandex-unofficial";
  version = "0.99.1";

  outputs = [
    "out"
    "sdk"
  ];

  src = fetchFromGitHub {
    owner = "Regrau";
    repo = "pulumi-yandex";
    tag = "v${version}";
    hash = "sha256-LCWrt5TIvzXssLjV523K27LWzd+za88WLzgbLLnK+sw=";
  };

  sourceRoot = "${src.name}/provider";

  vendorHash = "sha256-fGFLyywt48iDTCvfhUYkVZTWgcIpr9NtSIczq5j6NrE=";
  proxyVendor = true;

  env.GOWORK = "off";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/regrau/pulumi-yandex/provider/pkg/version.Version=${version}"
  ];

  excludedPackages = [
    "cmd/pulumi-tfgen-yandex"
  ];

  codegen = buildPackages.buildGoModule {
    pname = "pulumi-tfgen-yandex";
    inherit
      src
      version
      sourceRoot
      vendorHash
      proxyVendor
      ldflags
      ;
    env.GOWORK = "off";
    subPackages = [
      "cmd/pulumi-tfgen-yandex"
      "cmd/pulumi-resource-yandex/generate.go"
    ];
  };

  # https://github.com/Regrau/pulumi-yandex/blob/5c5e918ddf95f906752c020b7d6094154d759944/Makefile#L53
  postConfigure = ''
    pushd ..
    "$codegen"/bin/pulumi-tfgen-yandex schema --out provider/cmd/pulumi-resource-yandex
    popd
    pushd cmd/pulumi-resource-yandex
    VERSION=$version "$codegen"/bin/generate
    popd
  '';

  postInstall = ''
    for lang in go nodejs python; do
      "$codegen"/bin/pulumi-tfgen-yandex "$lang" --out "$sdk/$lang"
    done
    cp -t "$sdk/python" ../README.md
    substituteInPlace "$sdk/python/setup.py" \
      --replace-fail 'VERSION = "0.0.0"' "VERSION = \"$version\""
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.schema = testResourceSchema {
    name = "yandex";
    package = pulumi-yandex-unofficial;
  };

  passthru.sdks.python = python3Packages.pulumi-yandex-unofficial;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Pulumi package for creating and managing Yandex Cloud resources";
    mainProgram = "pulumi-resource-yandex";
    homepage = "https://github.com/Regrau/pulumi-yandex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
