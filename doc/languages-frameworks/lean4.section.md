# Lean 4 {#sec-language-lean4}

Lean 4 is a strict functional language with dependent types. `leanPackages` provides the toolchain and a curated set of libraries — including the full mathlib dependency tree — with its own Lean toolchain. A standalone compiler is also available as `pkgs.lean4` for use outside the package set.

## Building Lean 4 projects with `buildLakePackage` {#lean4-buildLakePackage}

```nix
leanPackages.buildLakePackage {
  pname = "my-project";
  version = "0.1.0";
  src = ./.;
  leanDeps = with leanPackages; [ mathlib ];
  lakeHash = null; # all deps nix-managed; set to lib.fakeHash for Lake-managed deps
}
```

Dependencies are declared in the lakefile for Lake and in the Nix expression for Nix. `leanDeps` provides Nix-managed libraries whose `.olean` files — the default build artifact of the Lake library facet — are reused without recompilation. `buildLakePackage` injects them via `lake --packages`, which takes precedence over Lake's own dependency resolution, producing a hermetic build.

Sui generis among nixpkgs builders, `buildLakePackage` supports heterogeneous dependency resolution, in that Nix transparently substitutes for upstream-managed dependencies at per-package granularity: Nix-managed dependencies via `leanDeps` and Lake-managed dependencies via `lakeHash` compose in the same derivation. Setting `lakeHash = lib.fakeHash` and building will report the expected hash for a fixed-output derivation that pins what Lake would normally fetch, less Nix-managed dependencies. Nix-managed dependencies take precedence by name — so moving a dependency from `lakeHash` to `leanDeps` will change the expected hash — providing an on-ramp for projects to incrementally adopt nix-managed libraries. Setting `lakeHash = null` (the default) declares that all dependencies are Nix-managed and no fixed-output fetch is performed during the build.

A `lake-manifest.json` is required at the project root. If all dependencies are Nix-managed, an empty manifest suffices:

```json
{"version":"1.1.0","packagesDir":".lake/packages","packages":[]}
```

## Development shells {#lean4-dev-shells}

In `nix develop`, the scoped `lean4` and `buildLakePackage` provide the same toolchain used for hermetic builds. Note that Lake's normal dependency resolution is available in the shell — Lake may fetch dependencies not covered by `leanDeps` from the network, as is standard for Nix development shells.

## The `leanPackages` scope {#lean4-leanPackages}

`leanPackages` is a `lib.makeScope` with its own `lean4`. Overriding it propagates to all packages and to `buildLakePackage`:

```nix
leanPackages.overrideScope (
  self: super: {
    lean4 = myCustomLean4;
  }
)
```

The `lean4` supplied by `leanPackages` is binary-patched to ensure that the Lean language server discovers the wrapped `lake` rather than an unwrapped one. This is necessary because Lake's `serve` subcommand has a vexing invocation pattern: it derives `LAKE` from `IO.appPath` and unconditionally sets it in the spawned environment, bypassing any wrapper. The binary patch rewrites store path references so that this discovery mechanism finds the correct binary, enabling LSP integration — including the InfoView, which requires Lean-specific protocol extensions — without improper mutation of the user's project directory.

Note that `leanPackages.lean4` supplants Lake's built-in cache invalidation for dependencies in `/nix/store/`, deferring entirely to Nix's bespoke dependency model. Lake's trace validation — which checks compiler "hash," platform, and package identity — is gracefully subsumed by guarantees Nix already provides. Cache coherence responsibilities are delegated to the orchestrator of streamlined Nix integration.

For Emacs, `emacsPackages.nael` and `emacsPackages.nael-lsp` (eglot-based and lsp-mode-based respectively, available via MELPA) provide Lean 4 support including proof state display via eldoc. For VSCode (unfree) / VSCodium, `vscode-extensions.leanprover.lean4` is available. Editor packages discover the toolchain from `PATH`.

## Relationship to earlier Lean 4 Nix support {#lean4-history}

Users familiar with the per-module derivation approach (2020–2025) should note that `buildLakePackage` follows a different architecture. The earlier integration discovered dependencies at evaluation time via import-from-derivation — an ambitious attempt to reconcile declarative package management with fine-grained build semantics, ultimately undermined by Nix's own evaluation model. It was [removed upstream](https://github.com/leanprover/lean4/commit/535435955b482176e8d62a54deebcacdec0827db). `buildLakePackage` treats Lake as a build driver and uses Nix for package-level boundaries, while `nix develop` and `nix-shell` achieve feature parity with the vanilla Lake development experience.
