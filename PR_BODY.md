## Summary

Adds a `withSignal` toggle (default `false`) that pulls in nchat's third chat backend, mirroring the existing WhatsApp wiring.

The change is **opt-in by default** to avoid silently changing the license of an installed `nchat`: `libsignal_ffi` is AGPLv3 and gets statically linked into the combined binary. Existing users see no behavior change.

Mechanically:

- `libcgosg` — second `buildGoModule` wraps `lib/sgchat/go` (the bundled `mautrix-signal`) and produces `libcgosg.a`, mirroring the existing `libcgowm`.
- `libsignalFfi` — `rustPlatform.buildRustPackage` building `libsignal_ffi` from `signalapp/libsignal v0.87.5` (the version pinned by nchat at `lib/sgchat/go/ext/signal/pkg/libsignalgo/version.go`). Built from source — nothing is fetched at build time, sidestepping nchat's CMake-time download/build dance.
- `go-libs-build-signal.patch` — rewires `lib/sgchat/CMakeLists.txt` to consume the prebuilt archives instead of running nchat's in-tree build chain (mirrors what `go-libs-build.patch` already does for wmchat).
- `meta.license` becomes `[ mit agpl3Only ]` when Signal is enabled.
- `meta.description` is derived from the actually-enabled set of protocols.

## Build notes

Three details discovered while building, surfaced here so a reviewer doesn't need to rediscover them:

1. `boring-sys` (signalapp/boring fork at `signal-v5.0.2`) runs `git init` on its vendored boringssl during its build script → needs `git` in `nativeBuildInputs` and explicit `GIT_AUTHOR_*` / `GIT_COMMITTER_*` env vars in `preBuild`.
2. `bindgen` (pulled by boring-sys) needs `LIBCLANG_PATH` → use `rustPlatform.bindgenHook`.
3. `cargoBuildFlags = [ "--release" ]` collides with `cargoBuildHook`'s implicit `--profile release` (modern cargo rejects the combination) → just pass `--package libsignal-ffi`.

## Things done

- Built on platform:
  - [x] x86_64-linux (built locally + via `nixpkgs-review wip`)
  - [ ] aarch64-linux (untested; should work — `libsignal_ffi` upstream supports arm64, `boring-sys` does too)
  - [ ] x86_64-darwin
  - [ ] aarch64-darwin
- Tested, as applicable:
  - [ ] NixOS tests
  - [ ] Package tests at `passthru.tests` (none exist for nchat)
  - [ ] Tests in lib/tests or pkgs/test
- [x] Ran `nixpkgs-review` on this PR.
- [x] Tested basic functionality:
  - `nchat --version` outputs the combined-AGPL distribution string (only appears when `HAS_SIGNAL=ON`)
  - `ldd` confirms `libsgchat.so` is linked
  - Default build (`withSignal = false`) verified unchanged (same closure as today)
  - Signal account linking not tested end-to-end (requires interactive phone-number / linked-device flow against a real Signal server)
- Nixpkgs Release Notes
  - [ ] N/A — additive change, default off.
- NixOS Release Notes
  - [ ] N/A — no module changes.
- [x] Fits CONTRIBUTING.md, pkgs/README.md, maintainers/README.md — existing maintainers preserved, `nix-update-script` callback unchanged.

## Cross-platform notes for reviewers

The Darwin link line in `go-libs-build-signal.patch` is structurally analogous to the existing Linux patch (uses `-force_load` instead of `--whole-archive`) but **was not built on Darwin**. Reviewers with macOS sandboxes are warmly invited to flip `withSignal = true;` and report.
