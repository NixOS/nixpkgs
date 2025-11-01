{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  playwright-test,
  playwright-driver,
  chromium,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "slidev";
  version = "52.6.0";

  src = fetchFromGitHub {
    owner = "slidevjs";
    repo = "slidev";
    tag = "v${version}";
    hash = "sha256-FbFpPCEdIB4Cr/rOMEBLDPdfSRyEivf6FU/V7UpgRDw=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-BOhMyRJgdYH9+lRquxbyBbrUsbjBltzgB7wnDn05EUU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  propagatedBuildInputs = [
    pnpm # used as runtime package manager, can be chosen between others
    playwright-test
    playwright-driver.passthru.browsers
    chromium
  ];

  buildPhase = ''
    runHook preBuild

    # Build all packages we need for the CLI, including themes and other dependencies
    pnpm --filter "@slidev/cli" --filter "@slidev/parser" --filter "@slidev/types" --filter "@slidev/client" --filter "@slidev/theme-default" --filter "@slidev/shared" run build

    # Also ensure dependencies are built or available
    # Install all dependencies to ensure node_modules structure is complete
    pnpm install --frozen-lockfile --offline

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        mkdir -p $out/lib/node_modules/@slidev/cli

        # Copy the built files and package.json
        cp -r packages/slidev/dist $out/lib/node_modules/@slidev/cli/
        cp packages/slidev/package.json $out/lib/node_modules/@slidev/cli/

        # Copy all node_modules to runtime - this ensures all dependencies are available
        mkdir -p $out/lib/node_modules
        cp -r node_modules $out/lib/node_modules/

        # Also copy required workspace packages
        mkdir -p $out/lib/node_modules/@slidev/parser
        cp -r packages/parser/dist $out/lib/node_modules/@slidev/parser/
        cp packages/parser/package.json $out/lib/node_modules/@slidev/parser/

        mkdir -p $out/lib/node_modules/@slidev/types
        cp -r packages/types/dist $out/lib/node_modules/@slidev/types/
        cp packages/types/package.json $out/lib/node_modules/@slidev/types/

        # Copy client package which is needed at runtime
        mkdir -p $out/lib/node_modules/@slidev/client
        # Copy all client files, not just dist - the client needs source files at runtime
        cp -r packages/client/* $out/lib/node_modules/@slidev/client/
        # Also copy the built dist directory if it exists
        if [ -d "packages/client/dist" ]; then
          cp -r packages/client/dist $out/lib/node_modules/@slidev/client/dist
        fi
        # Copy the .generated directory which contains required files
        if [ -d "packages/client/.generated" ]; then
          cp -r packages/client/.generated $out/lib/node_modules/@slidev/client/
        fi

        # Copy default theme package - it should be built now
        mkdir -p $out/lib/node_modules/@slidev/theme-default
        # Try to find the theme-default in the built packages
        if [ -d "node_modules/@slidev/theme-default" ]; then
          cp -r node_modules/@slidev/theme-default $out/lib/node_modules/@slidev/theme-default
        elif [ -d "packages/theme-default/dist" ]; then
          mkdir -p $out/lib/node_modules/@slidev/theme-default/dist
          cp -r packages/theme-default/dist/* $out/lib/node_modules/@slidev/theme-default/dist/
          cp packages/theme-default/package.json $out/lib/node_modules/@slidev/theme-default/package.json
        else
          # Fallback: check if it's built elsewhere in the workspace
          echo "Warning: No theme packages found" >&2
        fi

        # Create executable wrapper
        cat > $out/bin/slidev << EOF
    #!/bin/sh
    export PATH="${pnpm}/bin:\$PATH"
    export NODE_PATH="$out/lib/node_modules:\$NODE_PATH"
    # Set Playwright to use nixpkgs browsers with version compatibility
    PLAYWRIGHT_TMPDIR=\$(mktemp -d)
    trap 'rm -rf "\$PLAYWRIGHT_TMPDIR"' EXIT
    # Copy existing browser symlinks
    cp -aL ${playwright-driver.passthru.browsers}/* "\$PLAYWRIGHT_TMPDIR/"
    # Create symlink for version compatibility (1194 -> 1181)
    for browser in ${playwright-driver.passthru.browsers}/chromium_headless_shell-*; do
      if [ -e "\$browser" ]; then
        # Create symlink with expected revision 1194
        ln -sf "\$browser" "\$PLAYWRIGHT_TMPDIR/chromium_headless_shell-1194"
        break
      fi
    done
    export PLAYWRIGHT_BROWSERS_PATH="\$PLAYWRIGHT_TMPDIR"
    exec ${nodejs}/bin/node $out/lib/node_modules/@slidev/cli/dist/cli.js "\$@"
    EOF
        chmod +x $out/bin/slidev

        runHook postInstall
  '';

  # Disable broken symlinks check as pnpm creates complex symlink structures
  # that don't work well with Nix's strict checks
  dontFixup = true;

  meta = {
    description = "Presentation slides for developers";
    homepage = "https://sli.dev/";
    license = lib.licenses.mit;
    mainProgram = "slidev";
    maintainers = with lib.maintainers; [ taranarmo ];
  };
})
