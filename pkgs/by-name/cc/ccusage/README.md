# ccusage Package for nixpkgs

This directory contains the nixpkgs package definition for `ccusage`, a CLI tool for analyzing Claude Code token usage and costs.

## Package Structure

- `package.nix` - Main package definition following nixpkgs best practices
- `README.md` - This documentation file

## Build Process

The package uses `stdenv.mkDerivation` with the following key features:

1. **Dependency Management**: Uses npm install during build phase to handle dependencies (upstream uses bun.lock)
2. **Clean Patches**: Safely removes problematic workspace references and git hooks that interfere with the build
3. **Build Configuration**: Uses TypeScript compilation via `tsdown` to generate distribution files
4. **Runtime Dependencies**: Includes Node.js as a build input for CLI functionality

## Upstream Information

- **Repository**: https://github.com/ryoppippi/ccusage
- **License**: MIT
- **Language**: TypeScript (builds to JavaScript with tsdown)
- **Package Manager**: Bun (uses npm during nixpkgs build process)

## Maintenance

The package includes automated update scripts and version testing to ensure it stays current with upstream releases.

## Testing

Run the following to test the package:

```bash
# Build the package
nix-build -A ccusage

# Test version output
nix-shell -p ccusage --run "ccusage --version"
```

## Contributing

When updating this package:

1. Update the version in `package.nix`
2. Update the source hash
3. Test the build process to ensure dependencies resolve correctly
4. Verify the TypeScript compilation works with any upstream changes

For major version updates, review the upstream changes for any new dependencies or build requirements.
