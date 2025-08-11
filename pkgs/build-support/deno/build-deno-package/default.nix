# NOTE: much of this structure is inspired from https://github.com/NixOS/nixpkgs/tree/fff29a3e5f7991512e790617d1a693df5f3550f6/pkgs/build-support/node
{
  stdenvNoCC,
  deno,
  diffutils,
  zip,
  jq,
  fetchDenoDeps,
  buildPackages,
  lib,
  callPackage,
}:
{
  name ? "${args.pname}-${args.version}",
  src ? null,
  # The output hash of the dependencies for this project.
  denoDepsHash ? lib.fakeHash,
  # The host platform, the output binary is compiled for.
  hostPlatform ? stdenvNoCC.hostPlatform.system,
  # TODO: impure env vars passthru for npm tokens and deno auth tokens
  # TODO: source overrides like in buildNpmPackage
  denoDeps ? null,
  # The package used for every deno command in the build
  denoPackage ? deno,
  # The package used as the runtime that is bundled with the the src to create the binary.
  denortPackage ? deno,
  # The script to run to build the project.
  # You still need to specify in the installPhase, what artifacts to copy to `$out`.
  denoTaskScript ? "build",
  # If not null, create a binary using the specified path as the entrypoint,
  # copy it to `$out/bin` in installPhase and fix it in fixupPhase.
  binaryEntrypointPath ? null,
  # Flags to pass to all deno commands.
  denoFlags ? [ ],
  # Flags to pass to `deno task [denoTaskFlags] ${denoTaskScript}`.
  denoTaskFlags ? [ ],
  # Flags to pass to `deno compile [denoTaskFlags] ${binaryEntrypointPath}`.
  denoCompileFlags ? [ ],
  # Flags to pass to `deno install [denoInstallFlags]`.
  denoInstallFlags ? [
    "--frozen"
    "--cached-only"
  ],
  # Flags to pass to `deno task [denoTaskFlags] ${denoTaskScript} [extraTaskFlags]`.
  extraTaskFlags ? [ ],
  # Flags to pass to `deno compile [denoTaskFlags] ${binaryEntrypointPath} [extraCompileFlags]`.
  extraCompileFlags ? [ ],
  nativeBuildInputs ? [ ],
  dontFixup ? true,
  # Custom denoConfigHook
  denoConfigHook ? null,
  # Custom denoBuildHook
  denoBuildHook ? null,
  # Custom denoInstallHook
  denoInstallHook ? null,
  # Path to deno workspace, where the denoTaskScript should be run, also used when compiling
  denoWorkspacePath ? null,
  # Unquoted string injected before `deno task`
  denoTaskPrefix ? "",
  # Unquoted string injected after `deno task` and all its flags
  denoTaskSuffix ? "",
  ...
}@args:
let

  inherit (callPackage ../fetch-deno-deps/scripts/deno/default.nix { }) fetch-deno-deps-scripts;
  inherit (callPackage ../fetch-deno-deps/scripts/rust/file-transformer-vendor/default.nix { })
    file-transformer-vendor
    ;

  denoFlags_ = builtins.concatStringsSep " " denoFlags;
  denoTaskFlags_ = builtins.concatStringsSep " " denoTaskFlags;
  denoCompileFlags_ = builtins.concatStringsSep " " denoCompileFlags;
  denoInstallFlags_ = builtins.concatStringsSep " " denoInstallFlags;
  extraTaskFlags_ = builtins.concatStringsSep " " extraTaskFlags;
  extraCompileFlags_ = builtins.concatStringsSep " " extraCompileFlags;

  args' = builtins.removeAttrs args [ "denoDepsInjectedEnvVars" ];

  denoHooks = buildPackages.denoHooks {
    inherit
      denoTaskSuffix
      denoTaskPrefix
      binaryEntrypointPath
      denortPackage
      ;
  };

  systemLookupTable = {
    "x86_64-darwin" = "x86_64-apple-darwin";
    "arm64-darwin" = "aarch64-apple-darwin";
    "aarch64-darwin" = "aarch64-apple-darwin";
    "x86_64-linux" = "x86_64-unknown-linux-gnu";
    "arm64-linux" = "aarch64-unknown-linux-gnu";
    "aarch64-linux" = "aarch64-unknown-linux-gnu";
  };

  hostPlatform_ =
    if builtins.hasAttr hostPlatform systemLookupTable then
      systemLookupTable."${hostPlatform}"
    else
      (lib.systems.elaborate hostPlatform).config;

  tsTypesJson = (callPackage ../ts-types-preprocessor/default.nix { }).ts-types-json { inherit src; };

  denoDeps' =
    if denoDeps != null then
      denoDeps
    else
      fetchDenoDeps {
        inherit
          vendorJsonName
          npmJsonName
          tsTypesJson
          ;
        denoLock = src + "/deno.lock";
        name = "${name}-deno-deps";
        hash = denoDepsHash;
      };

  vendorJsonName = "vendor.json";
  npmJsonName = "npm.json";
  denoDir = ".deno";
  vendorDir = "vendor";
in
stdenvNoCC.mkDerivation (
  args'
  // {
    inherit
      name
      src
      denoFlags_
      denoTaskFlags_
      denoCompileFlags_
      denoInstallFlags_
      extraTaskFlags_
      extraCompileFlags_
      binaryEntrypointPath
      hostPlatform_
      denoWorkspacePath
      denoTaskScript
      vendorDir
      vendorJsonName
      npmJsonName
      ;

    tsTypesJsonPath = "${tsTypesJson}";
    denoDeps = denoDeps'.fetched;

    nativeBuildInputs = nativeBuildInputs ++ [
      # Prefer passed hooks
      (if denoConfigHook != null then denoConfigHook else denoHooks.denoConfigHook)
      (if denoBuildHook != null then denoBuildHook else denoHooks.denoBuildHook)
      (if denoInstallHook != null then denoInstallHook else denoHooks.denoInstallHook)
      denoPackage
      diffutils
      zip
      jq
      fetch-deno-deps-scripts
      file-transformer-vendor
    ];

    DENO_DIR = denoDir;

    dontFixup = if binaryEntrypointPath != null then false else dontFixup;

    passthru = {
      denoDeps = denoDeps';
      tsTypesJson = tsTypesJson;
    };

    meta = (args.meta or { }) // {
      platforms = args.meta.platforms or denoPackage.meta.platforms;
    };
  }
)
