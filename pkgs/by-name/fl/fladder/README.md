# Building Fladder

This package has placeholder hashes that need to be resolved during the build process.

## Getting the correct hashes

1. First, try to build the package:
   ```bash
   nix-build -A fladder
   ```

2. The build will fail with an error showing the expected hash for the source. Update the `hash` in `package.nix`:
   ```nix
   src = fetchFromGitHub {
     owner = "DonutWare";
     repo = "Fladder";
     rev = "v0.8.0";
     hash = "sha256-...";  # Replace with the hash from error message
   };
   ```

3. Try building again. It will now fail with the git dependency hash. Update `media_kit-hash`:
   ```nix
   gitHashes =
     let
       media_kit-hash = "sha256-...";  # Replace with hash from error message
     in
     { ... };
   ```

4. Continue building and fixing hashes until the package builds successfully.

## Testing the package

Once built successfully:

```bash
# Run the application
./result/bin/fladder

# Or install it to your profile
nix-env -f . -iA fladder
```

## Dependencies

This package requires:
- Flutter 3.35
- mpv-unwrapped (for media playback)
- sqlite (for database)
- Standard GTK3/Linux desktop dependencies
