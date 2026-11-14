{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  npmHooks,
  nodejs,
  patchelf,
  autoPatchelfHook,
  python3,
  rsync,
  libxcb,
  ripgrep,
  fd,
  makeWrapper,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  # Off is the smallest and fastest start, but an extension left to load from
  # its files then runs in JSC's interpreter instead of the JIT.
  jitSupport ? false,
  # Extension directories or entry files to compile into the executable.
  extensions ? [ ],
  # Bytecode size above which a function is left to the interpreter rather than
  # compiled; Bun's default is 262144. Compiling a bigger one takes minutes and
  # tens of GB of memory, so it is opt-in per build.
  aotBytecodeLimit ? null,
  # null: baseline on Linux (code for any CPU Bun runs on) and native on macOS.
  # "native" compiles for this CPU's instruction set (AVX2 class on x86-64) and
  # falls back to bytecode where it is not there: faster, but the executable
  # then runs properly only on CPUs like this one.
  cpu ? null,
  # This package itself, which is where passthru.withExtensions gets the
  # `.override` that re-calls this file with other extensions.
  pi-bolt,
}:
let
  inherit (stdenv) hostPlatform;
  version = "1.2.1";

  # Kept separate so update.sh can bump it like runtimeStamp.
  npmDepsHash = "sha256-clSwqY+pfiFyVXwlTOd1Y1f3tsGZE0X3ffamtLpkUX0=";

  # The AOT engine (patched Bun + WebKit) is released as a signed binary; the
  # application is compiled from source against it. Its stamp is the release's
  # RUNTIME_STAMP (unchanged since 1.0.7).
  runtimeStamp = "9606e2f852e92ee9";
  runtimeAssets = {
    x86_64-linux = fetchurl {
      url = "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v1.2.1/pi-bolt-runtime-linux-x64.tar.gz";
      hash = "sha256-JdfExfjaUb0hzY7ChOmbDa22u0f6nO7QcS6eMJPckzc=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v1.2.1/pi-bolt-runtime-linux-arm64.tar.gz";
      hash = "sha256-gKVweKbshoBqtbpOTYM2yo1Sz0IV7YjMl8ef+3YMaeI=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v1.2.1/pi-bolt-runtime-darwin-arm64.tar.gz";
      hash = "sha256-bvWiB5AkoZGs1c80Ehtl/EEg+yqxB1+M5YLt2hMkt70=";
    };
  };
  runtimeSrc =
    runtimeAssets.${hostPlatform.system}
      or (throw "pi-bolt: unsupported platform ${hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pi-bolt";
  inherit version;

  src = fetchFromGitHub {
    owner = "opensec-git";
    repo = "Pi-Bolt";
    tag = "bolt-v${version}";
    hash = "sha256-Dx5i+i9nbPKQ4mdBye2V6GA0NPD/I2hAzN0ZAqhPKms=";
  };

  inherit runtimeSrc;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = npmDepsHash;
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    python3
    rsync
    makeWrapper
  ]
  ++ lib.optionals hostPlatform.isLinux [
    patchelf
    autoPatchelfHook
  ];
  buildInputs = lib.optionals hostPlatform.isLinux [ libxcb ];

  npmRebuildFlags = [ "--ignore-scripts" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  postUnpack = ''
    mkdir -p $TMPDIR/runtime
    tar -xzf ${finalAttrs.runtimeSrc} --strip-components=1 -C $TMPDIR/runtime
    chmod -R u+w $TMPDIR/runtime
  ''
  + lib.optionalString hostPlatform.isLinux ''
    # The compile links against this, and rewriting the compiled executable
    # afterwards would damage its AOT image.
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $TMPDIR/runtime/bun
  '';

  # 1.2.0's build runs a biome-based schema check. The generated files are
  # committed, and the npm deps are installed without lifecycle scripts, so
  # biome's platform binary is not usable.
  # Skip the check; tsc still compiles the committed generated files.
  postPatch = ''
    substituteInPlace packages/coding-agent/package.json \
      --replace-fail 'npm run generate:start-schemas -- --check && ' ""

    # jiti reuses a cached transform while the extension's source is unchanged,
    # whatever produced it: a cache directory shared by two builds hands one
    # Babel's output to the other and crashes Bun. Salt it with the version so
    # a build only reads what it wrote.
    substituteInPlace packages/coding-agent/src/core/extensions/loader.ts \
      --replace-fail 'path.join(getAgentDir(), "cache", "jiti")' \
      'path.join(getAgentDir(), "cache", "jiti", "${version}")'

    # Pi's loader still resolves the older name for its own typebox, but the
    # manifest build maps only the paths listed here, so a compiled-in
    # extension that uses it would need a second copy installed instead.
    python3 - <<'PY'
    import json
    with open("tsconfig.json") as handle:
        config = json.load(handle)
    config["compilerOptions"]["paths"]["@sinclair/typebox"] = ["./node_modules/typebox"]
    with open("tsconfig.json", "w") as handle:
        json.dump(config, handle, indent="\t")
        handle.write("\n")
    PY
  '';

  buildPhase = ''
    runHook preBuild

    npm run build:offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    patchShebangs scripts
    mkdir -p $out/lib $out/bin $TMPDIR/plugins
    # build-pi.sh compiles a manifest's folder along with the manifest, so each
    # extension is put in a directory of its own beside it. What an extension's
    # entries are is pi's rule (resolveExtensionEntries and what it collects).
    python3 - $TMPDIR/plugins ${lib.escapeShellArgs (map (extension: "${extension}") extensions)} <<'PY'
    import json, os, re, shutil, sys

    def resolve(directory):
        """Pi's rule: the package.json pi.extensions list, else index.ts/index.js, else its own .ts/.js files."""
        manifest = os.path.join(directory, "package.json")
        declared = []
        if os.path.isfile(manifest):
            with open(manifest) as handle:
                declared = (json.load(handle).get("pi") or {}).get("extensions") or []
        found = []
        for entry in declared:
            entry = os.path.join(directory, entry)
            if os.path.isfile(entry):
                found.append(entry)
            elif os.path.isdir(entry) and os.path.realpath(entry) != os.path.realpath(directory):
                found.extend(resolve(entry))
        if not found:
            found = [os.path.join(directory, name) for name in ("index.ts", "index.js")]
            found = [entry for entry in found if os.path.isfile(entry)]
        if not found:
            found = sorted(
                os.path.join(directory, name)
                for name in os.listdir(directory)
                if name.endswith((".ts", ".js")) and not name.startswith(".")
            )
        return found

    def package_root(path):
        """The directory of the package.json a file belongs to: an extension's imports can reach above its entry."""
        directory = path if os.path.isdir(path) else os.path.dirname(path)
        while True:
            if os.path.isfile(os.path.join(directory, "package.json")):
                return directory
            parent = os.path.dirname(directory)
            if parent == directory or os.path.basename(directory) == "node_modules":
                return None
            directory = parent

    def dependencies(path):
        """The node_modules a path resolves its own imports from, if it is inside one."""
        directory = path if os.path.isdir(path) else os.path.dirname(path)
        while directory != "/":
            if os.path.basename(directory) == "node_modules":
                return directory
            directory = os.path.dirname(directory)
        return None

    out, extensions = sys.argv[1], sys.argv[2:]
    imports, entries, roots = [], [], set()

    for extension in extensions:
        path = os.path.realpath(extension)
        if not os.path.exists(path):
            sys.exit(f"pi-bolt: {extension} does not exist")
        found = [path] if os.path.isfile(path) else resolve(path)
        if not found:
            sys.exit(f"pi-bolt: {extension} has no extension entry")

        manifest = os.path.join(path, "package.json")
        package = None
        if os.path.isfile(manifest):
            with open(manifest) as handle:
                package = json.load(handle).get("name")
        # A file from a source tree is its own store path (`<hash>-name.ts`), and the
        # hash must not end up in the built-in's name.
        label = package or re.sub(
            r"^[0-9a-z]{32}-", "", os.path.splitext(os.path.basename(path))[0]
        )
        roots.add(dependencies(path))

        # A named entry is a built-in extension (`builtin:<name>`): it can be turned
        # off, and a run-time copy of it replaces it rather than adding a second set
        # of tools.
        for entry in found:
            name = re.sub(r"[^A-Za-z0-9._:-]", "-", label).strip("-")
            if len(found) > 1:
                name = f"{name}-{os.path.splitext(os.path.basename(entry))[0]}"
            while name in [existing for existing, _ in entries]:
                name = f"{name}-{len(entries)}"
            variable = f"extension{len(entries)}"
            copied = os.path.join(out, variable)
            root = package_root(entry) or os.path.dirname(entry)
            if not os.path.isdir(copied):
                # Copied, not linked: the build maps Pi's own packages with a
                # tsconfig beside the staged folder, and bun applies it to the files
                # that are there, not to where a symlink points. The package root,
                # because an extension's imports reach outside its own folder.
                shutil.copytree(root, copied, symlinks=True)
            relative = os.path.relpath(entry, root)
            imports.append(f'import {variable} from "./{variable}/{relative}";')
            entries.append((name, variable))

    if entries:
        roots.discard(None)
        if len(roots) > 1:
            sys.exit("pi-bolt: extensions from several node_modules trees: " + ", ".join(sorted(roots)))
        if roots:
            # The extensions' own dependencies, resolved as they are installed. Copied
            # too: a dependency that imports one of Pi's packages needs the same
            # mapping the extensions get.
            tree = os.path.join(out, "node_modules")
            shutil.copytree(roots.pop(), tree, symlinks=True)
            # linkedom loads node-canvas for image decoding if it can; nothing here
            # builds it, so the bundle gets an empty module rather than a missing one
            # (only a <canvas> element needs it).
            if not os.path.isdir(os.path.join(tree, "canvas")):
                os.chmod(tree, 0o755)
                os.makedirs(os.path.join(tree, "canvas"))
                with open(os.path.join(tree, "canvas", "package.json"), "w") as handle:
                    handle.write('{ "name": "canvas", "main": "index.js" }\n')
                with open(os.path.join(tree, "canvas", "index.js"), "w") as handle:
                    handle.write("module.exports = {};\n")
        with open(os.path.join(out, "plugins.ts"), "w") as handle:
            handle.write("".join(f"{line}\n" for line in imports))
            handle.write("export default [\n")
            for name, variable in entries:
                handle.write(f'\t{{ name: "{name}", factory: {variable} }},\n')
            handle.write("];\n")
    PY

    # copytree keeps the store's read-only modes; the build rsyncs this folder
    # into Pi's tree and then removes the copy.
    chmod -R u+rwX $TMPDIR/plugins

    pluginArgs=()
    if [ -f $TMPDIR/plugins/plugins.ts ]; then
      pluginArgs=(--plugins $TMPDIR/plugins/plugins.ts)
    fi

    ${lib.optionalString (
      aotBytecodeLimit != null
    ) "export BUN_JSC_maximumAOTCandidateBytecodeSize=${toString aotBytecodeLimit}"}

    PIBOLT_WORK=$TMPDIR/work \
    PIBOLT_BUN=$TMPDIR/runtime/bun \
    PIBOLT_RUNTIME_STAMP=${runtimeStamp} \
    ./scripts/build-pi.sh \
        --cpu ${
          if cpu != null then
            cpu
          else if hostPlatform.isDarwin then
            "native"
          else
            "baseline"
        } \
        --jit ${if jitSupport then "on" else "off"} \
        "''${pluginArgs[@]}" \
        --out $out/lib/pi-bolt

    # No JITI_FS_CACHE: setting it, to anything, drops pi's own cache directory
    # (loader.ts, salted above) for jiti's system-wide temporary one.
    makeWrapper $out/lib/pi-bolt/pi $out/bin/pi-bolt \
      --prefix PATH : ${
        lib.makeBinPath [
          ripgrep
          fd
        ]
      }

    runHook postInstall
  '';

  # The executable is an AOT image: stripping or patching it damages it. Only
  # the native modules are patched.
  dontStrip = true;
  dontPatchELF = true;
  dontAutoPatchelf = true;

  strictDeps = true;
  __structuredAttrs = true;

  postFixup = lib.optionalString hostPlatform.isLinux ''
    autoPatchelf $out/lib/pi-bolt/native
  '';

  passthru = {
    inherit runtimeAssets;

    withExtensions = exts: pi-bolt.override { extensions = exts; };

    tests = {
      # A `--version` string alone does not prove the AOT payload was loaded:
      # the Bun runtime prints its own version too. Bun reports whether the
      # static heap image was registered.
      aot =
        runCommand "${finalAttrs.pname}-aot-image-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
            meta.timeout = 60;
          }
          ''
            output=$(HOME=$TMPDIR BUN_STATIC_HEAP_VERBOSE=1 pi-bolt --version 2>&1)
            if ! grep -q 'image registered: true' <<< "$output"; then
              echo "pi-bolt did not register its AOT image (Bun CLI fallback?):" >&2
              echo "$output" >&2
              exit 1
            fi
            touch $out
          '';
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Ahead-of-time compiled build of the pi coding agent, built from source";
    homepage = "https://github.com/opensec-git/Pi-Bolt";
    downloadPage = "https://github.com/opensec-git/Pi-Bolt/releases";
    changelog = "https://github.com/opensec-git/Pi-Bolt/releases";
    # Pi-Bolt and Bun are MIT; the bundled WebKit is LGPL-2.0-or-later and
    # BSD-2-Clause per file (THIRD_PARTY_NOTICES.md).
    license = with lib.licenses; [
      mit
      lgpl2Plus
      bsd2
    ];
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode
    ];
    # Only x86_64-linux has been built. Upstream publishes aarch64 assets too,
    # but the derivation is untested there; widen this once it has been built.
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.darrenmeehan ];
    mainProgram = "pi-bolt";
  };
})
