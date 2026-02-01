{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  python3,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "quartz";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "v${version}";
    hash = "sha256-A6ePeNmcsbtKVnm7hVFOyjyc7gRYvXuG0XXQ6fvTLEw=";
  };

  npmDepsHash = "sha256-xxK9qy04m1olekOJIyYJHfdkYFzpjsgcfyFPuKsHpKE=";

  postPatch = ''
            # Modify constants.js to work with global installation
            substituteInPlace quartz/cli/constants.js \
              --replace 'import path from "path"' 'import path from "path"
        import { fileURLToPath } from "url"' \
              --replace 'export const { version } = JSON.parse(readFileSync("./package.json").toString())' '// Try to read package.json from current directory first, then from Quartz installation directory
        let packageJson;
        try {
          packageJson = JSON.parse(readFileSync("./package.json").toString())
        } catch (e) {
          const __filename = fileURLToPath(import.meta.url)
          const quartzPackageJson = path.join(path.dirname(__filename), "..", "..", "package.json")
          packageJson = JSON.parse(readFileSync(quartzPackageJson).toString())
        }
        export const { version } = packageJson'

            # Fix the create handler to copy template files from installation directory
            substituteInPlace quartz/cli/handlers.js \
              --replace-fail 'import { promises } from "fs"' 'import { promises } from "fs"
    import { fileURLToPath } from "url"' \
              --replace-fail 'const configFilePath = path.join(cwd, "quartz.config.ts")
      let configContent = await fs.promises.readFile(configFilePath, { encoding: "utf-8" })' 'const templateFiles = ["quartz.config.ts", "quartz.layout.ts", "tsconfig.json", "package.json"];
      const __filename = fileURLToPath(import.meta.url);
      const installDir = path.join(path.dirname(__filename), "..", "..");

      for (const templateFile of templateFiles) {
        const targetPath = path.join(cwd, templateFile);
        if (!fs.existsSync(targetPath)) {
          const sourcePath = path.join(installDir, templateFile);
          if (fs.existsSync(sourcePath)) {
            await fs.promises.copyFile(sourcePath, targetPath);
            await fs.promises.chmod(targetPath, 0o644);
          }
        }
      }

      const configFilePath = path.join(cwd, "quartz.config.ts")
      let configContent = await fs.promises.readFile(configFilePath, { encoding: "utf-8" })'
  '';

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  buildInputs = [
    vips
  ];

  # Skip build phase as Quartz is designed to be used as a template/CLI tool
  dontNpmBuild = true;

  postInstall = ''
        # Ensure the CLI script is executable
        chmod +x $out/lib/node_modules/@jackyzha0/quartz/quartz/bootstrap-cli.mjs

        # Create a wrapper script for the quartz command
        mkdir -p $out/bin
        cat > $out/bin/quartz << EOF
    #!/usr/bin/env bash
    # Quartz needs to run from within a project directory that contains package.json
    # For the 'create' command, it can run from anywhere, but other commands need a Quartz project

    QUARTZ_PATH="$out/lib/node_modules/@jackyzha0/quartz/quartz/bootstrap-cli.mjs"

    # Check if this is the create command or help
    if [[ "\$1" == "create" ]] || [[ "\$1" == "--help" ]] || [[ "\$1" == "-h" ]] || [[ "\$1" == "--version" ]] || [[ "\$1" == "-v" ]] || [[ \$# -eq 0 ]]; then
        exec ${nodejs}/bin/node "\$QUARTZ_PATH" "\$@"
    else
        # For other commands, check if we're in a Quartz project directory
        if [[ ! -f "package.json" ]]; then
            echo "Error: Quartz must be run from within a Quartz project directory."
            echo "Use 'quartz create' to initialize a new Quartz project first."
            echo "See 'quartz --help' for more information."
            exit 1
        fi
        exec ${nodejs}/bin/node "\$QUARTZ_PATH" "\$@"
    fi
    EOF
        chmod +x $out/bin/quartz
  '';

  # Tests require network access and are not suitable for the build environment
  doCheck = false;

  meta = {
    description = "A static-site generator that transforms Markdown content into feature-rich websites";
    longDescription = ''
      Quartz is a static site generator that transforms Markdown content into
      feature-rich websites. It features Obsidian compatibility, full-text
      search, graph view, wikilinks, backlinks, LaTeX support, syntax highlighting,
      popover previews, and many more features right out of the box.

      Use 'quartz create' to initialize a new Quartz project, then run other
      commands from within the project directory.
    '';
    homepage = "https://quartz.jzhao.xyz";
    changelog = "https://github.com/jackyzha0/quartz/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "quartz";
    platforms = lib.platforms.all;
    # Requires Node.js >= 22
    broken = lib.versionOlder nodejs.version "22.0.0";
  };
}
