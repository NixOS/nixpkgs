# Builds nativos, WASM, suítes de teste, clippy, reprodutibilidade e testes
# funcionais executados por `nix flake check`.
{
  pkgs,
  packages,
  toolchain,
}:

let
  inherit (pkgs) lib;

  moduleConfig =
    (import (pkgs.path + "/nixos/lib/eval-config.nix") {
      system = pkgs.stdenv.hostPlatform.system;
      modules = [
        ../modules/arkhe-node.nix
        ../modules/arkhe-audit.nix
        {
          services.arkheNode = {
            enable = true;
            package = pkgs.hello;
            environmentFile = "/run/secrets/arkhe.env";
          };
          services.arkheAudit = {
            enable = true;
            package = pkgs.hello;
          };
          system.stateVersion = "26.05";
        }
      ];
    }).config;

  checkable = lib.filterAttrs (name: value: lib.isDerivation value) packages;

  # Segunda construção independente: mesma derivação com uma variável a
  # mais, logo outro caminho de saída, outro sandbox e outro horário.
  # `diff -r` compara byte a byte. Não varia caminho de build (/build) nem
  # kernel; para isso use scripts/check-reproducibility.sh em outra máquina.
  reproducible =
    name: pkg:
    let
      again = pkg.overrideAttrs { ARKHE_REPRO_SECOND_BUILD = "1"; };
    in
    pkgs.runCommand "arkhe-reproducible-${name}" { } ''
      if ! diff -r ${pkg} ${again}; then
        echo "NAO REPRODUTIVEL: ${name}" >&2
        echo "  1: ${pkg}" >&2
        echo "  2: ${again}" >&2
        exit 1
      fi
      mkdir -p $out
      echo "${pkg}" > $out/first
      echo "${again}" > $out/second
    '';
in
lib.removeAttrs checkable [ "arkhe-verify-cli" ]
// lib.mapAttrs' (name: value: lib.nameValuePair "tests-${name}" value) packages.tests
// {
  # O snapshot em source/ confere com source-manifest.json (SHA-256 por arquivo).
  source-manifest =
    pkgs.runCommand "arkhe-source-manifest"
      {
        nativeBuildInputs = [ pkgs.python3 ];
      }
      ''
        mkdir -p arkhe/scripts
        cp ${../scripts/validate-source.py} arkhe/scripts/validate-source.py
        cp ${../source-manifest.json} arkhe/source-manifest.json
        ln -s ${../source} arkhe/source
        python3 arkhe/scripts/validate-source.py | tee $out
      '';

  # A toolchain que compilou os pacotes é a do rust-toolchain.toml.
  toolchain-version = pkgs.runCommand "arkhe-toolchain-version" { } ''
    ${toolchain.native}/bin/rustc --version | tee $out
    grep -q '^rustc ${lib.escapeRegex toolchain.channel} ' $out
  '';

  reproducible-arkhe-verify = reproducible "arkhe-verify" packages.arkhe-verify;
  reproducible-arkhe-verify-wasm = reproducible "arkhe-verify-wasm" packages.arkhe-verify-wasm;
  reproducible-arkhe-sdd-parser = reproducible "arkhe-sdd-parser" packages.arkhe-sdd-parser;

  modules =
    assert moduleConfig.systemd.services.arkhe-runtime.serviceConfig.EnvironmentFile == "/run/secrets/arkhe.env";
    assert builtins.length moduleConfig.environment.systemPackages >= 1;
    pkgs.runCommand "arkhe-modules-eval" { } "touch $out";

  wasm-smoke = pkgs.runCommand "arkhe-wasm-smoke" { nativeBuildInputs = [ pkgs.nodejs ]; } ''
    mkdir -p $out
    node ${./wasm-smoke.cjs} ${packages.arkhe-verify-wasm}/lib ${./fixtures/mmr} > $out/results.json
  '';

  smoke = pkgs.runCommand "arkhe-verify-smoke" { } ''
    mkdir -p $out
    ${packages.arkhe-verify}/bin/arkhe-verify --help > $out/help.txt
  '';

  # spec.md/tasks.md -> CBOR: exit 0 (V1 satisfeito) e bytes idênticos em
  # duas execuções.
  sdd-parser-smoke = pkgs.runCommand "arkhe-sdd-parser-smoke" { } ''
    parser=${packages.arkhe-sdd-parser}/bin/arkhe-sdd-parser
    mkdir -p $out
    $parser --spec ${./fixtures/sdd/spec.md} --tasks ${./fixtures/sdd/tasks.md} --out $out/run1 > $out/report.json
    $parser --spec ${./fixtures/sdd/spec.md} --tasks ${./fixtures/sdd/tasks.md} --out $out/run2 > /dev/null
    cmp $out/run1/constitution.cbor $out/run2/constitution.cbor
    cmp $out/run1/tasks.cbor $out/run2/tasks.cbor
    grep -q '"v1_satisfied": true' $out/report.json
  '';
}
