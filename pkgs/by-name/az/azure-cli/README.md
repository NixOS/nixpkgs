# Azure CLI

## Updating the CLI

- Update `version` and `src.hash` in package.nix
- Check out the changes made to the azure-cli [setup.py](https://github.com/Azure/azure-cli/blob/dev/src/azure-cli/setup.py) since the last release
- Try build the CLI, will likely fail with `ModuleNotFoundError`, for example
  ```
   ModuleNotFoundError: No module named 'azure.mgmt.storage.v2023_05_01'
  ```
  Sometimes it will also fail with other import errors.
- Check the referenced module (`azure-mgmt-storage`) in the setup.py
- Find the actual version required, for example
  ```
    'azure-mgmt-storage==21.2.0',
  ```
- Update version and hash of this dependency in python-packages.nix
- Repeat until it builds

## Extensions

There are two sets of extensions:

- `extensions-generated.nix` are extensions with no external requirements, which can be regenerated running:
  > nix run .#azure-cli.passthru.generate-extensions

- `extensions-manual.nix` are extensions with requirements, which need to be manually packaged and maintained.

### Adding an extension to `extensions-manual.nix`

To manually add a missing extension, first query its metadata from the extension index.
Use the following command, use the current version of azure-cli in nixpkgs as `cli-version`
and the name of the extension you want to package as `extension`:

```sh
nix run .#azure-cli.extension-tool -- \
  --cli-version=2.61.0 \
  --extension=azure-devops \
  --init
```

The output should look something like this:

```json
{
  "pname": "azure-devops",
  "version": "1.0.2",
  "url": "https://github.com/Azure/azure-devops-cli-extension/releases/download/20250624.2/azure_devops-1.0.2-py2.py3-none-any.whl",
  "hash": "sha256-4rDeAqOnRRKMP26MJxG4u9vBuos6/SQIoVgfNbBpulk=",
  "description": "Tools for managing Azure DevOps",
  "license": "MIT",
  "requirements": [
    "distro (>=1.6.0)"
  ]
}
```

Based on this, you can add an attribute to `extensions-manual.nix`:

```nix
{
  azure-devops = mkAzExtension {
    pname = "azure-devops";
    version = "1.0.2";
    url = "https://github.com/Azure/azure-devops-cli-extension/releases/download/20250624.2/azure_devops-${version}-py2.py3-none-any.whl";
    hash = "sha256-4rDeAqOnRRKMP26MJxG4u9vBuos6/SQIoVgfNbBpulk=";
    description = "Tools for managing Azure DevOps";
    propagatedBuildInputs = with python3Packages; [ distro ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };
}
```

* The attribute name should be the same as `pname`.
* Replace the version in `url` with `${version}`.
* The json output `requirements` must be transformed into package `requirements`.
* If `license` is `"MIT"`, it can be left out in the nix expression, as the builder defaults to that license.
* Add yourself as maintainer in `meta.maintainers`.

### Testing extensions

You can build azure-cli with an extension on the command line by running the following command at the root of this repository:

```sh
nix build --impure --expr 'with (import ./. {}); azure-cli.withExtensions [ azure-cli.extensions.azure-devops ]'
```

Check if the desired functionality was added.

You can check if the extensions were recognized by running:

```sh
./result/bin/az extension list
```

The output should show the extension like this:

```sh
[
  {
    "experimental": false,
    "extensionType": "whl",
    "name": "azure-devops",
    "path": "/nix/store/azbgnpg5nh5rb8wfvp0r9bmcx83mqrj5-azure-cli-extensions/azure-devops",
    "preview": false,
    "version": "1.0.0"
  }
]
```

### Removing an extension

If extensions are removed upstream, an alias is added to the end of `extensions-manual.nix`
(see `# Removed extensions`). This alias should throw an error and be of similar structure as
this example:

```nix
{
  blockchain = throw "The 'blockchain' extension for azure-cli was deprecated upstream"; # Added 2024-04-26
}
```
