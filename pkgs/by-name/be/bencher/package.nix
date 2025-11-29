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
  version = "0.5.8";

  # When updating, also make sure to update npmDeps.hash in bencher-console!
  src = fetchFromGitHub {
    owner = "bencherdev";
    repo = "bencher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nz+j8Iwjy4Ziw/L8D7SK3AFRIWP4QQyu63mQnc7dh4o=";
  };

  cargoHash = "sha256-3jiBz1gWO9klTeXMqVL16qczJptPf9HVksitiGversI=";

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
