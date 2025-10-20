{
  lib,
  stdenv,

  fetchFromGitHub,
  rustPlatform,

  fontconfig,
  mold,
  pkg-config,

  withCli ? true,
  withApi ? true,
}:
assert withCli || withApi;

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bencher";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iv0BScnDYVtkMnvGv3JysamuOANRNpvY8+ZC32aa2iA=";
  };

  cargoHash = "sha256-9Uf2XvBjZUudrfrLQCu4lCsGLx1zUz95nkNrMHTekm8=";

  cargoBuildFlags = lib.cli.toGNUCommandLine { } {
    package =
      lib.optionals withApi [
        "bencher_api"
      ]
      ++ lib.optionals withCli [
        "bencher_cli"
      ];
  };

  # The default features include `plus` which has a custom license
  buildNoDefaultFeatures = true;

  # does dlopen() libfontconfig during tests and at runtime
  RUSTFLAGS = lib.optionalString stdenv.targetPlatform.isElf "-C link-arg=-Wl,--add-needed,${fontconfig.lib}/lib/libfontconfig.so";

  nativeBuildInputs = [
    # .cargo/config.toml selects mold
    mold
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  checkFlags = [
    "--skip=licensor::test::test_bencher_cloud_annual"
    "--skip=licensor::test::test_bencher_cloud_monthly"
  ];

  postInstall = ''
    mv $out/bin/api $out/bin/bencher-api
  '';

  meta = {
    description = "Suite of continuous benchmarking tools";
    homepage = "https://bencher.dev";
    changelog = "https://github.com/bencherdev/bencher/releases/tag/v${finalAttrs.version}";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [
      flokli
    ];
    platforms = lib.platforms.unix;
    mainProgram = "bencher";
  };
})
