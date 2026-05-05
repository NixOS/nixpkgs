# Visual Studio Code Extensions

## Conventions for adding new extensions

* Extensions are named in the **lowercase** version of the extension's unique identifier which is found on the extension's marketplace page, and is the name under which the extension is installed by VSCode under `~/.vscode`.
  Extension location should be: ${lib.strings.toLower mktplcRef.publisher}.${lib.string.toLower mktplcRef.name}

* When adding a new extension, place its definition in a `default.nix` file in a directory with the extension's ID (e.g. `publisher.extension-name/default.nix`) and refer to it in `./default.nix`, e.g. `publisher.extension-name = callPackage ./publisher.extension-name { };`.

* Use `nix-shell --run treefmt` to format the VSCode extensions.

* Respect `alphabetical order` whenever adding extensions. If out of order, please kindly open a PR re-establishing the order.

* Avoid [unnecessary](https://nix.dev/guides/best-practices.html#with-scopes) use of `with`, particularly `nested with`.

* Use `hash` instead of `sha256`.

* Add `signatureHash` to enable automatic cryptographic signature verification (optional) or pass `--with-signature` to the update script to populate it.
  For multi-platform extensions with per-system `hash` values, the update script fetches a `signatureHash` per platform and inserts it into each per-system block.

  Signature verification runs only when the `vscode` package exposes `passthru.hasVsceSign = true`.
  Microsoft's build does; `vscodium` does not because it ships without the `vsce-sign` binary).
  Users who overlay `vscode = vscodium` or other variant without `vsce-sign` get verification automatically skipped.

  For per-extension opt-out set `allowMissingVsceSign = true` via `overrideAttrs`: `(pkgs.vscode-extensions.publisher.extension.overrideAttrs { allowMissingVsceSign = true; })`.

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
