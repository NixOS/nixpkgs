# Reprodutibilidade e endereçamento por conteúdo

## Configuração atual: Rust 1.96.0

`flake.lock` fixa nixpkgs e rust-overlay por revisão e narHash. O rust-overlay fornece tarballs oficiais do compilador e das bibliotecas padrão, cada um com SHA-256 fixo. `lib/toolchain.nix` lê o canal exato de `source/rust-toolchain.toml` (1.96.0); o snapshot coincide com o arquivo do workspace original. A variante WASM usa o mesmo compilador com std de `wasm32-unknown-unknown`. O devShell e clippy usam os componentes declarados nesse arquivo.

Os pacotes usam `rustPlatform.buildRustPackage`, `cargoLock.lockFile` do snapshot e os checksums do `Cargo.lock` original. A compilação usa `--locked`, `--offline`, `CARGO_NET_OFFLINE=true` e sandbox. O download prévio de insumos fixados é separado da fase de compilação.

`SOURCE_DATE_EPOCH=315532800`, `CARGO_INCREMENTAL=0`, `TZ=UTC`, `LC_ALL=C` e remapeamento de caminhos mantêm o ambiente explícito. Uma inspeção dos três artefatos prioritários confirmou ausência dos prefixos locais `/mnt/d/arkhe`, `/home/arkhen` e `D:\arkhe`.

## Fonte por pacote

`lib/workspace.nix` calcula o fecho de dependências `path`, incluindo build-dependencies e as dev-dependencies dos crates testados. Só o código desse fecho e fixtures de compilação declaradas entram no `src`. A descoberta parte dos membros explícitos do workspace e de suas dependências por caminho; projetos Cargo avulsos abaixo da raiz não são descobertos. Diretórios de build/ambiente e o `pkg/` gerado de wasm-bindgen são excluídos. Manifestos dos demais crates e o `Cargo.lock` compartilhado permanecem disponíveis para o resolver Cargo; alvos vazios desses crates são criados em `postPatch`, sem compilá-los.

Mudanças no lock ou nos manifestos podem alterar o hash, pois afetam a resolução de dependências. Edições no código de um crate não usado não alteram o `src` nem a derivação do pacote. `scripts/check-source-filter.py` verifica isso alterando apenas uma cópia temporária de `arkhe-ask`: verifier, WASM e SDD permanecem idênticos, enquanto o controle positivo `arkhe-ask` muda. O probe também adiciona um projeto Cargo não declarado e altera um arquivo gerado do WASM, sem alterar os três alvos prioritários. O CI repete o probe.

## Como verificar em WSL/Linux

Abra o Ubuntu WSL e execute:

```bash
source ~/.nix-profile/etc/profile.d/nix.sh
cd /mnt/d/arkhe/work/nixpkgs-arkhe-integration/arkhe
export NIX_CONFIG='experimental-features = nix-command flakes'
python3 scripts/validate-source.py
python3 scripts/check-source-filter.py
nix build .#arkhe-verify-cli .#arkhe-verify-wasm .#arkhe-sdd-parser --no-update-lock-file
nix flake check --no-update-lock-file -L
./scripts/check-reproducibility.sh arkhe-verify-cli arkhe-verify-wasm arkhe-sdd-parser
```

`arkhe-verify` executa as suítes CLI/core/verifier em `checkPhase`. Os alvos `arkhe-core --test golden_vectors` e `arkhe-verify-core --test golden_contract` são obrigatórios e precisam executar pelo menos um teste aprovado. Os checks `tests-arkhe-core`, `tests-arkhe-kernel` e `tests-arkhe-governance` exercitam as bibliotecas; o primeiro exige novamente o alvo golden_vectors.

Os checks `reproducible-*` fazem uma segunda construção com variável de ambiente adicional e comparam as saídas com `diff -r`. O script acima é complementar: usa `nix build --rebuild`, desativa substituição e compara a mesma derivação com a saída já registrada. Uma diferença provoca falha; `--keep-failed` permite inspecionar a saída com diffoscope.

O smoke test SDD executa o CLI e compara `constitution.cbor` e `tasks.cbor` de duas execuções. O smoke WASM executa provas MMR válidas e adulteradas via bindings Node.js. Clippy tem duas exceções documentadas no README; não é uma alegação de ausência de todos os lints.

## Endereçamento por conteúdo

CA é opt-in: `__contentAddressed=true`, `outputHashMode="recursive"` e `outputHashAlgo="sha256"`. As variantes ficam em `legacyPackages.<system>.ca`. Isso permite o endereço final depender do conteúdo produzido, mas exige a feature experimental `ca-derivations` nos avaliadores/builders e suporte às realisations no cache utilizado. Não substitui a comparação de builds nem torna uma compilação não determinística em determinística.

```bash
nix build .#legacyPackages.x86_64-linux.ca.arkhe-verify-cli \
  --extra-experimental-features 'nix-command flakes ca-derivations'
bash scripts/verify-content-addressing.sh arkhe-verify-cli
```

A variante CA do verificador foi construída e inspecionada nesta rodada. O modo comum continua como padrão para manter compatibilidade. Os insumos já são fixados: fontes Git pelo lock do consumidor/commit e pelo manifesto SHA-256 do snapshot, crates pelos checksums do Cargo.lock, compilador/std pelos hashes do rust-overlay.

## Evidências e limites

[Resultados Rust 1.96.0](validation/rust-1.96.0/results.json) registram 24 checks válidos em x86_64-linux, três reconstruções reais bit-idênticas, hashes, versão do compilador, isolamento de fonte e inspeção de caminhos. Os logs das suítes e do toolchain estão no mesmo diretório. A verificação usa insumos fixados; não afirma igualdade entre arquiteturas ou versões diferentes.

O bit executável do checkout participa do hash do `src`. DrvFS e um checkout Git em ext4 podem produzir fontes/derivações com caminhos distintos mesmo quando o conteúdo compilado coincide. Para comparar ambientes, confira o narHash das saídas; CA também pode normalizar o endereço final quando o conteúdo coincide. O README preserva a observação entre checkouts registrada na revisão 5cf45f52f.

A [rodada de VM anterior](INTEGRATION-REVIEW.md) usava Rust 1.99.0 do nixpkgs. Seus resultados permanecem históricos; a reprodução em VM não foi repetida para Rust 1.96.0. Nesta rodada, aarch64 foi declarado no flake mas seus builds não foram executados.
