# CloudQuery Plugin Architecture

This directory implements a scalable plugin system for CloudQuery similar to Packer and Terraform providers. The architecture makes it easy to add, maintain, and version CloudQuery plugins independently while providing convenient bundling via the `withPlugins` function.

## Directory Structure

```
cloudquery/
├── package.nix             # Main CLI package with plugin builders and withPlugins function
├── plugins/
│   ├── sources.nix         # Registry of all source plugins
│   └── destinations.nix    # Registry of all destination plugins
└── README.md               # This file
```

## Architecture Overview

### Core Components

The plugin system is built on three main components:

1. **fetchOfficialPlugin**: A wrapper around `fetchFromGitHub` that automatically resolves to the CloudQuery repository
2. **buildOfficialPlugin**: A `lib.extendMkDerivation` builder that handles standard plugin builds
3. **Plugin Registries**: Two separate registries (`sources.nix`, `destinations.nix`) that declare all available plugins

### Plugin Builder

The `buildOfficialPlugin` function is a reusable builder that handles:

- Standard Go module building
- Source fetching from GitHub
- Plugin naming conventions (`cloudquery-{type}-{name}`)
- Binary renaming and cleanup
- Common metadata

**Example plugin definition:**

```nix
buildOfficialPlugin (fa: {
  pluginType = "source"; # or "destination"
  pluginName = "aws"; # from upstream
  version = "1.2.3"; # from upstream
  src = fetchOfficialPlugin {
    inherit (fa) pluginType pluginName version;
    hash = "sha256-...";
  };
  vendorHash = "sha256-...";
  doCheck = false; # most plugins skip tests because they require network access or external services.
})
```

### Plugin Registries

Plugins are organized in two registries based on type:

**Source Plugins (`plugins/sources.nix`)** - Fetch data from external sources, for example:

```nix
{
  aws = buildOfficialPlugin (fa: {
    pluginType = "source";
    pluginName = "aws";
    version = "1.2.3";
    src = fetchOfficialPlugin {
      inherit (fa) pluginType pluginName version;
      hash = "sha256-...";
    };
    vendorHash = "sha256-...";
    doCheck = false;
  });
}
```

**Destination Plugins (`plugins/destinations.nix`)** - Write data to external destinations, for example:

```nix
{
  postgresql = buildOfficialPlugin (fa: {
    pluginType = "destination";
    pluginName = "postgresql";
    version = "4.5.6";
    src = fetchOfficialPlugin {
      inherit (fa) pluginType pluginName version;
      hash = "sha256-...";
    };
    vendorHash = "sha256-...";
    doCheck = false;
  });
}
```

## Usage

### Building the CloudQuery CLI

```bash
nix build .#cloudquery
```

### Building Individual Plugins

```bash
nix build .#cloudquery.plugins.sources.aws
nix build .#cloudquery.plugins.destinations.postgresql
```

### Using withPlugins to Bundle CloudQuery with Plugins

The `cloudquery.withPlugins` function creates a wrapped CloudQuery binary with plugins automatically available via the `NIX_CQ_PLUGINS` environment variable:

```nix
pkgs.cloudquery.withPlugins [
  pkgs.cloudquery.plugins.sources.aws
  pkgs.cloudquery.plugins.destinations.postgresql
]
```

**In NixOS Configuration:**

```nix
{
  environment.systemPackages = [
    (pkgs.cloudquery.withPlugins [
      pkgs.cloudquery.plugins.sources.aws
      pkgs.cloudquery.plugins.destinations.postgresql
    ])
  ];
}
```

**In a Development Shell:**

```nix
# shell.nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = [
    (pkgs.cloudquery.withPlugins [
      pkgs.cloudquery.plugins.sources.aws
      pkgs.cloudquery.plugins.destinations.postgresql
    ])
  ];
}
```

#### How withPlugins Works

The `withPlugins` function:
1. Takes a list of plugin derivations
2. Creates a symlink tree combining all plugins in a single directory
3. Wraps the cloudquery binary with the `NIX_CQ_PLUGINS` environment variable pointing to this directory
4. This variable needs to be interpolated into the plugin path in the corresponding config, so `cloudquery` can find the executable when it runs

This is useful when you want a pre-configured CloudQuery environment with specific plugins without having to manage multiple packages.

## Writing CloudQuery Configurations

When using `cloudquery.withPlugins`, your configuration files must reference bundled plugins using `registry: local` as well as a path that starts with the `${NIX_CQ_PLUGINS}` environment variable.
This variable is automatically set by the wrapper to point to the directory containing the bundled plugins.

### Plugin Path Format

Plugin paths must follow this format:

```yaml
path: "${NIX_CQ_PLUGINS}/cloudquery-{type}-{name}"
registry: local
```

Where:
- `{type}` is either `source` or `destination`
- `{name}` is the plugin name (e.g., `aws`, `postgresql`)

### Example Configuration

Here's a complete CloudQuery configuration that sources data from AWS and writes to PostgreSQL:

```yaml
# Source: AWS
kind: source
spec:
  name: aws
  path: "${NIX_CQ_PLUGINS}/cloudquery-source-aws"
  registry: local
  spec:
    # AWS-specific options
    regions: ["us-east-1", "us-west-2"]
  tables: ["aws_ec2_instances", "aws_s3_buckets"]
  destinations: ["postgresql"]

# Destination: PostgreSQL
kind: destination
spec:
  name: postgresql
  path: "${NIX_CQ_PLUGINS}/cloudquery-destination-postgresql"
  registry: local
  spec:
    connection_string: "postgres://user:password@localhost:5432/cloudquery"
```

## Adding New Plugins

### Adding a Source Plugin

1. Add entry to `plugins/sources.nix`, for example:

```nix
{
  azure = buildOfficialPlugin (fa: {
    pluginType = "source";
    pluginName = "azure";
    version = "1.0.0";
    src = fetchOfficialPlugin {
      inherit (fa) pluginType pluginName version;
      hash = "sha256-xxxxx...";
    };
    vendorHash = "sha256-yyyyy...";
    doCheck = false;
    # Optional customizations:
    preBuild = ''
      # Custom pre-build steps
    '';
    postInstall = ''
      # Custom post-install steps
    '';
  });
}
```

2. Update hashes:
   - `hash`: SHA256 of the source tarball from GitHub
   - `vendorHash`: SHA256 of Go dependencies

   Run `nix-prefetch-url` to get the hash, or let nix fail and use the suggested hash.

3. Test the build:

```bash
nix build .#cloudquery.plugins.sources.azure
```

### Adding a Destination Plugin

Same process as source plugins but add to `plugins/destinations.nix`:

```nix
{
  elasticsearch = buildOfficialPlugin (fa: {
    pluginType = "destination";
    pluginName = "elasticsearch";
    version = "1.0.0";
    src = fetchOfficialPlugin {
      inherit (fa) pluginType pluginName version;
      hash = "sha256-xxxxx...";
    };
    vendorHash = "sha256-yyyyy...";
    doCheck = false;
  });
}
```

## Versioning and Updates

Each plugin is independently versioned. To update a plugin:

1. Find the appropriate entry in `plugins/sources.nix` or `plugins/destinations.nix`
2. Update the `version` field to the new version
3. Update the `hash` and `vendorHash` fields (run the build to get the suggested hashes)

For automated updates with `nix-update`, each plugin can have its own update script.

## Troubleshooting

### Build Fails with Hash Mismatch

The plugin's source hash doesn't match. Run the build and copy the suggested hash:

```bash
nix build .#cloudquery.plugins.sources.aws 2>&1 | grep sha256
```

### Binary Not Found

Check that the `postInstall` phase correctly renames the binary to `cloudquery-{type}-{name}`. This is handled automatically by `buildOfficialPlugin`.

### Configuration Validation

Validate your CloudQuery configuration before running sync:

```bash
cloudquery validate-config config.yaml
```

With `withPlugins`, plugins are automatically available:

```bash
nix develop -c cloudquery validate-config config.yaml
```
