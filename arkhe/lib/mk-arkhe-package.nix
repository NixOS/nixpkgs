# Construtor único dos pacotes Arkhe para Nix.
#
# Determinismo aplicado:
#   - fonte por pacote (lib/workspace.nix): só o fecho de crates do pacote
#     entra no hash da fonte.
#   - `--locked` + `cargoLock.lockFile`: cada crate é resolvido pelo checksum
#     registrado no Cargo.lock; não existe versão flutuante. O vendor é o
#     mesmo para todos os pacotes (depende só do Cargo.lock).
#   - sandbox sem rede + `CARGO_NET_OFFLINE=true`.
#   - `SOURCE_DATE_EPOCH` fixo.
#   - `--remap-path-prefix` remove caminhos absolutos do binário.
#   - `RUSTFLAGS` explícito; o `.cargo/config.toml` do monorepo (-Dwarnings)
#     não faz parte do snapshot.
#
# `mode`:
#   "package"  build + install (checkPhase opcional);
#   "test"     só `cargo test` dos `testCrates`; a saída é o log;
#   "clippy"   só `cargo clippy` dos `testCrates`; a saída é o log.
{
  lib,
  stdenv,
  rustPlatform,
  workspace,
}:

{
  pname,
  crate ? pname,
  bin ? null,
  version ? "0.1.0",
  src ? null,
  mode ? "package",
  contentAddressed ? false,
  features ? [ ],
  noDefaultFeatures ? false,
  doCheck ? false,
  # Crates testados além de `crate` (com as dev-dependencies deles).
  testCrates ? [ ],
  # Alvos `--test` que precisam rodar com pelo menos um teste aprovado,
  # por exemplo [ { crate = "arkhe-core"; test = "golden_vectors"; } ].
  requiredTests ? [ ],
  cargoBuildFlags ? [ ],
  cargoTestFlags ? [ ],
  clippyFlags ? [ ],
  nativeBuildInputs ? [ ],
  buildInputs ? [ ],
  extraAttrs ? { },
  meta ? { },
}:

assert lib.elem mode [
  "package"
  "test"
  "clippy"
];

let
  isPackage = mode == "package";
  runsTests = isPackage && doCheck || mode == "test";
  testedCrates = lib.optionals (runsTests || mode == "clippy") ([ crate ] ++ testCrates);

  # `src` só é usado quando o chamador traz uma fonte não-path (por exemplo
  # um tarball fixado); nesse caso não há filtro por pacote.
  source =
    if workspace != null then
      workspace.sourceFor {
        crates = lib.optional isPackage crate;
        testCrates = testedCrates;
      }
    else
      {
        inherit src;
        lockFile = "${src}/Cargo.lock";
        postPatch = "";
        closureNames = null;
      };

  featureFlags =
    lib.optionals noDefaultFeatures [ "--no-default-features" ]
    ++ lib.optionals (features != [ ]) [
      "--features"
      (lib.concatStringsSep "," features)
    ];

  packageFlags = lib.concatMap (name: [
    "-p"
    name
  ]) testedCrates;

  # Mesmo alvo e perfil do cargoCheckHook no modo "package", para reaproveitar
  # o que ele já compilou.
  requiredTestTargetFlags = lib.optionals isPackage [
    "--target"
    stdenv.hostPlatform.rust.rustcTargetSpec
    "--profile"
    "release"
  ];

  # Falha se o alvo não rodou nenhum teste: protege contra um filtro que
  # esvazie a suíte silenciosamente.
  requiredTestsScript = lib.concatMapStrings (t: ''
    echo "== teste obrigatório: ${t.crate} --test ${t.test}"
    set -o pipefail
    cargo test --locked --offline -j "$NIX_BUILD_CORES" ${lib.escapeShellArgs requiredTestTargetFlags} \
      -p ${t.crate} --test ${t.test} 2>&1 | tee required-test.log
    grep -Eq '^test result: ok\. [1-9][0-9]* passed' required-test.log \
      || { echo "nixpkgs-arkhe: ${t.crate}/${t.test} não executou nenhum teste" >&2; exit 1; }
  '') requiredTests;

  modeAttrs =
    if isPackage then
      {
        cargoBuildFlags =
          [
            "--locked"
            "-p"
            crate
          ]
          ++ lib.optionals (bin != null) [
            "--bin"
            bin
          ]
          ++ featureFlags
          ++ cargoBuildFlags;

        cargoTestFlags = [ "--locked" ] ++ packageFlags ++ featureFlags ++ cargoTestFlags;

        inherit doCheck;
        postCheck = requiredTestsScript;
      }
    else
      {
        dontCargoBuild = true;
        dontCargoInstall = true;
        doCheck = true;
        checkPhase = ''
          runHook preCheck
          set -o pipefail
          ${
            if mode == "test" then
              ''
                cargo test --locked --offline -j "$NIX_BUILD_CORES" ${lib.escapeShellArgs (packageFlags ++ featureFlags ++ cargoTestFlags)} 2>&1 | tee cargo.log
                grep -Eq '^test result: ok\. [1-9][0-9]* passed' cargo.log \
                  || { echo "nixpkgs-arkhe: nenhum teste executado" >&2; exit 1; }
              ''
            else
              ''
                cargo clippy --locked --offline --keep-going -j "$NIX_BUILD_CORES" --all-targets ${lib.escapeShellArgs (packageFlags ++ featureFlags)} \
                  -- ${lib.escapeShellArgs clippyFlags} 2>&1 | tee cargo.log
              ''
          }
          ${requiredTestsScript}
          runHook postCheck
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp cargo.log $out/
          runHook postInstall
        '';
      };
in
rustPlatform.buildRustPackage (
  {
    inherit
      pname
      version
      nativeBuildInputs
      buildInputs
      ;
    inherit (source) src;

    cargoLock = {
      inherit (source) lockFile;
      allowBuiltinFetchGit = false;
    };

    postPatch = source.postPatch;

    SOURCE_DATE_EPOCH = 315532800;
    CARGO_INCREMENTAL = "0";
    CARGO_NET_OFFLINE = "true";
    TZ = "UTC";
    LC_ALL = "C";

    preBuild = ''
      export RUSTFLAGS="''${RUSTFLAGS-} --remap-path-prefix=$PWD=/build/source --remap-path-prefix=$NIX_BUILD_TOP=/build"
    '';

    passthru = {
      inherit
        crate
        bin
        contentAddressed
        mode
        ;
      sourceCrates = source.closureNames;
    };

    meta = {
      homepage = "https://github.com/rafael-arkhe/nixpkgs-arkhe";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    } // lib.optionalAttrs (bin != null) { mainProgram = bin; } // meta;
  }
  // modeAttrs
  // lib.optionalAttrs contentAddressed {
    __contentAddressed = true;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
  }
  // extraAttrs
)
