{
  lib,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  nixVersions,
  nixDependencies,
  makeWrapper,
  pkg-config,
  curl,
  jdk21,
  bash,
  python3,
  testers,
}:
let
  nix = nixVersions.nix_2_34;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jix";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hencjo";
    repo = "jix";
    tag = "jix-v${finalAttrs.version}";
    hash = "sha256-R5Ees9vhHLW4CRtscVzXaN90DZLIF50/NKYBtIgHBWI=";
  };

  cargoHash = "sha256-Q3ocPq+KVpQrKavzISFvmTrxoGWzYJGolN58o7b3I6Q=";

  # Keep the native ABI check exact, rather than accepting arbitrary Nix versions.
  # This affects the build copy, not the original release source used by init.
  patches = [ ./native-nix-2.34.9.patch ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    nix.dev
    nixDependencies.boost
    nixDependencies.boehmgc
  ];

  env = {
    # init imports the original release's flake and its committed tooling pins.
    JIX_FLAKE_SOURCE = "path:${finalAttrs.src}";
    JIX_ORACLE_HOME = callPackage ./oracle.nix { jixSource = finalAttrs.src; };
  };

  postPatch = ''
    patchShebangs tools/oracle/run.sh
  '';

  cargoTestFlags = [ "--workspace" ];
  nativeCheckInputs = [
    jdk21
    bash
    python3
    curl
  ];
  postCheck = ''
    (cd fixtures/published && sha256sum --check SHA256SUMS)
    python3 -B tools/test_differential.py
    cargo test --workspace --locked --offline --test differential -- --ignored
    cargo test -p jix --locked --offline --test matrix matrix_maven_parity -- --ignored
  '';

  postInstall = ''
    install -Dm644 LICENSE "$out/share/licenses/jix/LICENSE"
    wrapProgram "$out/bin/jix" --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$("$out/bin/jix" --version)" = "jix ${finalAttrs.version}"
    "$out/bin/jix" --help > /dev/null
    "$out/bin/jix" migrate --guide > guide.md
    test -s guide.md
    runHook postInstallCheck
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Nix-native Java dependencies and builds";
    homepage = "https://github.com/hencjo/jix";
    changelog = "https://github.com/hencjo/jix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.hencjo ];
    mainProgram = "jix";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
