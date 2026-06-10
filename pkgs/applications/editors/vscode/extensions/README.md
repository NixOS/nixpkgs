# Visual Studio Code Extensions

## Conventions for adding new extensions

* Extensions are named in the **lowercase** version of the extension's unique identifier which is found on the extension's marketplace page, and is the name under which the extension is installed by VSCode under `~/.vscode`.
  Extension location should be: ${lib.strings.toLower mktplcRef.publisher}.${lib.string.toLower mktplcRef.name}

* When adding a new extension, place its definition in a `default.nix` file in a directory with the extension's ID (e.g. `publisher.extension-name/default.nix`) and refer to it in `./default.nix`, e.g. `publisher.extension-name = callPackage ./publisher.extension-name { };`.

* Use `nix-shell --run treefmt` to format the VSCode extensions.

* Respect `alphabetical order` whenever adding extensions. If out of order, please kindly open a PR re-establishing the order.

* Avoid [unnecessary](https://nix.dev/guides/best-practices.html#with-scopes) use of `with`, particularly `nested with`.

* Use `hash` instead of `sha256`.

* Add `signatureHash` to pin the extension's Marketplace signature, or pass `--with-signature` to the update script to populate it.
  For multi-platform extensions with per-system `hash` values, the update script fetches a `signatureHash` per platform and inserts it into each per-system block.

  Passing `--with-signature` also verifies each pinned VSIX against its signature with Microsoft's `vsce-sign` on every supported platform, so a missing or invalid signature fails the update; pass `--skip-verify` to populate hashes without verifying.
  When updating through `nix-update` or `passthru.updateScript` (which cannot forward these flags), set `VSCODE_EXTENSION_WITH_SIGNATURE=1` (and optionally `VSCODE_EXTENSION_SKIP_VERIFY=1`) in the environment instead.
  Routine updates that only refresh an existing `signatureHash` (e.g. automated `r-ryantm` runs) do not verify, so they stay free and never pull the unfree `vsce-sign`.

  Build-time verification is opt-in: it re-checks the signature with `vsce-sign` during the build.
  Enable it per extension with `verifySignature = true`, or for every signed extension by setting `vscodeExtensions.verifySignature = true` in your nixpkgs config.
  This pulls the unfree `vsce-sign` (bundled with `vscode`) into the build closure, so it is off by default to keep extensions free-buildable on Hydra and usable with `vscodium`.
  It only runs when the `vscode` package exposes `passthru.hasVsceSign = true` (Microsoft's build does; `vscodium` does not), so overlaying `vscode = vscodium` skips it automatically.

* On `meta` field:
  - add a `changelog`.
  - `description` should mention it is a Visual Studio Code extension.
  - `downloadPage` is the VSCode marketplace URL.
  - `homepage` is the source-code URL.
  - `maintainers`:
    - optionally consider adding yourself as a maintainer to be notified of updates, breakages and help with upkeep.
    - recommended format is:
      - a `non-nested with`, such as: `with lib.maintainers; [ your-username ];`.
      - maintainers are listed in alphabetical order.
  - verify `license` in upstream.

* Commit messages:
  - Naming convention for:
    - Adding a new extension:

      > vscode-extensions.publisher.extension-name: init at 1.2.3
      >
      > Release: https://github.com/owner/project/releases/tag/1.2.3
    - Updating an extension:

      > vscode-extensions.publisher.extension-name: 1.2.3 -> 2.3.4
      >
      > Release: https://github.com/owner/project/releases/tag/2.3.4
  - Multiple extensions can be added in a single PR, but each extension requires its own commit.
