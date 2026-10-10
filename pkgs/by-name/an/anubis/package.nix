{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  nixosTests,
  stdenv,
  rustPlatform,
  npmHooks,
  nodejs,
  esbuild,
  brotli,
  zstd,
  cargo,
  bashInteractive,
  llvmPackages,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "anubis";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iB0DRagqPZfjmAYkmyf8HpRSz2oVUsJB5DXc9gBdHUM=";
  };

  vendorHash = "sha256-7TYCWky6ybc5iyNsLpY3XorwACs/9qMRq+oP5v9sW1I=";

  npmDeps = fetchNpmDeps {
    name = "anubis-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-HELLfMRf8JniTGqTLWz5WreRx3uWOQ7Jak2Sy99JQjM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-T0lZQyAJLFKrR2kQ2i/WHN15APlEwQ3jBP1w/GUYmuA=";
  };

  nativeBuildInputs = [
    esbuild
    brotli
    zstd

    nodejs
    npmHooks.npmConfigHook

    rustPlatform.cargoSetupHook
    cargo
    bashInteractive
    llvmPackages.lld
  ];

  subPackages = [ "cmd/anubis" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "-extldflags=-static" ];

  prePatch = ''
    # we must forcefully disable the hook when creating the go vendor archive
    if [[ $name =~ go-modules ]]; then
      npmConfigHook() { true; }
    fi
  '';

  postPatch = ''
    patchShebangs \
      ./wasm/scripts/build_*.sh \
      ./web/build.sh \
      ./lib/challenge/*/build.sh
  '';

  preBuild = ''
    # do not run when creating go vendor archive
    if [[ ! $name =~ go-modules ]]; then
      # https://github.com/TecharoHQ/anubis/blob/main/xess/build.sh
      npx postcss ./xess/xess.css -o xess/xess.min.css
      go generate ./...
      ./wasm/scripts/build_wasm.sh
      ./wasm/scripts/build_wasm2js.sh
      ./web/build.sh
    fi
  '';

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = { inherit (nixosTests) anubis; };
    updateScript = nix-update-script { extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ]; };
  };

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://anubis.techaro.lol/";
    downloadPage = "https://github.com/TecharoHQ/anubis";
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightpp
      soopyc
      ryand56
      defelo
    ];
    mainProgram = "anubis";
  };
})
