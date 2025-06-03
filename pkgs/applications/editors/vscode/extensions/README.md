# Visual Studio Code Extensions

## Conventions for adding new extensions

* Extensions are named in the **lowercase** version of the extension's unique identifier. Which is found on the marketplace extension page, and is the name under which the extension is installed by VSCode under `~/.vscode`.
  Extension location should be: ${lib.strings.toLower mktplcRef.publisher}.${lib.string.toLower mktplcRef.name}

* By default, extensions should be added in a discrete directory with the directory named according to the above convention. Most extension directories will contain a single `default.nix` file, but some may contain additional files for patches, update scripts, or other components. With the new default.nix file inside a directory, the global index file should be updated to include a `callPackage`.

* Currently `nixfmt-rfc-style` formatter is being used to format the VSCode extensions.

* Respect `alphabetical order` whenever adding extensions. On disorder, please, kindly open a PR re-establishing the order.

* Avoid [unnecessary](https://nix.dev/guides/best-practices.html#with-scopes) use of `with`, particularly `nested with`.

* Use `hash` instead of `sha256`.

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

* On commit messages:
  - Naming convention for:
    - Adding a new extension:

      > vscode-extensions.publisher.extension-name: init at 1.2.3
      >
      > Release: https://github.com/owner/project/releases/tag/1.2.3
    - Updating an extension:

      > vscode-extensions.publisher.extension-name: 1.2.3 -> 2.3.4
      >
      > Release: https://github.com/owner/project/releases/tag/2.3.4
  - Multiple extensions can be added in a single PR, but each extension requires it's own commit.
