# Visual Studio Code Extensions

## Conventions for adding new extensions

* Extensions are named in the **lowercase** version of the extension's unique identifier. Which is found on the marketplace extension page, and is the name under which the extension is installed by VSCode under `~/.vscode`.
  Extension location should be: ${lib.strings.toLower mktplcRef.publisher}.${lib.string.toLower mktplcRef.name}

* Move extension to a discrete directory whenever the extension needs extra parameters/packages (at top of the file) or other files (such as patches, update script, components). Global index file parameters/packages should be utilities shared by many extensions. Extension specific parameters/packages should not be in the global index page.

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
