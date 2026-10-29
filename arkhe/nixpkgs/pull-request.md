Adds `arkhe-verify`, the offline Arkhe artifact and attestation verifier. The
Cargo crate is named `arkhe-verify-cli`; the installed executable is
`arkhe-verify`.

The source is the validated Arkhe workspace snapshot, published with its original
Cargo.lock as an immutable, source-only commit in rafael-arkhe/nixpkgs-arkhe.
That repository is a Nixpkgs fork, but the pinned source commit has only the
Arkhe workspace at its root, rather than a Nixpkgs checkout. This is an unstable
snapshot, not a published v0.1.0 release.

Uses Nixpkgs' standard rustPlatform and fixed-output hashes for both source and
vendored dependencies. Build and tests run offline with `--frozen`. Includes the
CLI, verifier core and kernel core test suites, explicit nonempty golden-vector
and golden-contract tests, and a passthru BLAKE3 known-answer test.

The separate maintainer commit registers @rafael-arkhe, who has agreed to maintain
the package. WASM and the other Arkhe packages remain in the existing overlay;
this initial upstream contribution is limited to the native verifier.

Automation disclosure: OpenAI Codex (GPT-6) assisted with packaging, this summary
and verification scripts. The commits include `Assisted-by:` trailers. Human
self-review is required before submitting this proposal.

Validation on WSL Ubuntu x86_64-linux, against Nixpkgs
`0470df609861fede4cec47148a001f04513bdabc` with its standard Rust 1.99.0:
`nix-build -A arkhe-verify`, `nix-build -A arkhe-verify.tests`,
`nix-build -A arkhe-verify --check`, the maintainer schema test, nixfmt and
`git diff --check` all passed. The rebuild was bit-identical, with output NAR hash
`sha256-aVjRxtMiLJv/rvdYT+qPMMWF3zDMCaCeWbEN3cK5ak8=`.
This recipe has not been tested on another machine, aarch64 or Darwin.
`nixpkgs-review` was not run.

## Things done

- [ ] Fits [CONTRIBUTING.md], [pkgs/README.md], [maintainers/README.md] and other READMEs.
- [ ] Follows the [automation/AI policy].
- Built on platform:
  - [x] x86_64-linux
  - [ ] aarch64-linux
  - [ ] aarch64-darwin
- Tested, as applicable:
  - [x] Basic functionality of all binary files, usually in `./result/bin/`.
  - [ ] Ran `nixpkgs-review` on this PR. See [nixpkgs-review usage].
  - [x] [Package tests] at `passthru.tests`.
  - [ ] [NixOS tests] in [nixos/tests]. Not applicable; no NixOS module.
  - [x] Tests in [lib/tests] or [pkgs/test] for functions and "core" functionality. Maintainer schema validation passed.
- Nixpkgs Release Notes
  - [ ] Package update: when the change is major or breaking.
- NixOS Release Notes
  - [ ] Module addition: when adding a new NixOS module.
  - [ ] Module update: when the change is significant.

[Package tests]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests
[NixOS tests]: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests
[nixpkgs-review usage]: https://github.com/Mic92/nixpkgs-review#usage
[CONTRIBUTING.md]: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md
[automation/AI policy]: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#automationai-policy
[lib/tests]: https://github.com/NixOS/nixpkgs/blob/master/lib/tests
[maintainers/README.md]: https://github.com/NixOS/nixpkgs/blob/master/maintainers/README.md
[nixos/tests]: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests
[pkgs/README.md]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md
[pkgs/test]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/test
