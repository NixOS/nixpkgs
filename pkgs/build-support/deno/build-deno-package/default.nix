# NOTE: much of this structure is inspired from https://github.com/NixOS/nixpkgs/tree/fff29a3e5f7991512e790617d1a693df5f3550f6/pkgs/build-support/node
{
  stdenvNoCC,
  deno,
  denort,
  diffutils,
  zip,
  jq,
  fetchDenoDeps,
  buildPackages,
  lib,
}:
{
  name ? "${args.pname}-${args.version}",
  src ? null,
  # The output hash of the dependencies for this project.
  denoDepsHash ? lib.fakeHash,
  # The host platform, the output binary is compiled for.
  hostPlatform ? stdenvNoCC.hostPlatform.system,
  # A list of strings, which are names of impure env vars passed to the deps build.
  # Example:
  # `[ "NPM_TOKEN" ]`
  # They will be forwarded to `deno install`.
  # It can be used to set tokens for private NPM registries (in an `.npmrc` file).
  # In multi user installations of Nix, you need to set the env vars in the daemon (probably with systemd).
  # In nixos: `systemd.services.nix-daemon.environment.NPM_TOKEN = "<token>";`
  denoDepsImpureEnvVars ? [ ],
  # An attr set with env vars as key value pairs.
  # Example:
  # `{ "NPM_TOKEN" = "<token>"; }`
  # They will be forwarded to `deno install`.
  # It can be used to set tokens for private NPM registries (in an `.npmrc` file).
  # You could pass these tokens from the cli with `--arg` (this can make your builds painful).
  denoDepsInjectedEnvVars ? { },
  # TODO: source overrides like in buildNpmPackage, i.e. injecting nix packages into the denoDeps
  # this is more involved, since they can't directly be injected into the fixed output derivation
  # of fetchDenoDeps. Instead we need to patch the lock file and remove the packages we intend to
  # inject, then we need to build the rest of the packages like before and in a
  # second step create normal derivation with the injected packages.
  # then the two need to be merged into a single denoDeps derivation and finally the lock file needs
  # to be reverted back to it's original form.
  # It is possible to manipulate the registry.json files of the injected packages so that deno accepts them as is.
  denoDeps ? fetchDenoDeps {
    inherit
      src
      denoDepsInjectedEnvVars
      denoDepsImpureEnvVars
      denoFlags
      denoDir
      ;
    denoInstallFlags = builtins.filter (e: e != "--cached-only") denoInstallFlags;
    name = "${name}-deno-deps";
    hash = denoDepsHash;
  },
  # The package used for every deno command in the build
  denoPackage ? deno,
  # The package used as the runtime that is bundled with the the src to create the binary.
  denortPackage ? denort,
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
    "--allow-scripts"
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
  # Path to deno workspace, where the denoTaskScript should be run
  denoWorkspacePath ? null,
  # Unquoted string injected before `deno task`
  denoTaskPrefix ? "",
  # Unquoted string injected after `deno task` and all its flags
  denoTaskSuffix ? "",
  # Used as the name of the local DENO_DIR
  denoDir ? "./.deno",
  ...
}@args:
let
  denoFlags_ = builtins.concatStringsSep " " denoFlags;
  denoTaskFlags_ = builtins.concatStringsSep " " denoTaskFlags;
  denoCompileFlags_ = builtins.concatStringsSep " " denoCompileFlags;
  denoInstallFlags_ = builtins.concatStringsSep " " denoInstallFlags;
  extraTaskFlags_ = builtins.concatStringsSep " " extraTaskFlags;
  extraCompileFlags_ = builtins.concatStringsSep " " extraCompileFlags;

  args' = builtins.removeAttrs args [ "denoDepsInjectedEnvVars" ];

  denoHooks =
    (buildPackages.denoHooks.override {
      denort = denortPackage;
    })
      {
        inherit denoTaskSuffix denoTaskPrefix binaryEntrypointPath;
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
in
stdenvNoCC.mkDerivation (
  args'
  // {
    inherit
      name
      denoDeps
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
      ;

    nativeBuildInputs = nativeBuildInputs ++ [
      # Prefer passed hooks
      (if denoConfigHook != null then denoConfigHook else denoHooks.denoConfigHook)
      (if denoBuildHook != null then denoBuildHook else denoHooks.denoBuildHook)
      (if denoInstallHook != null then denoInstallHook else denoHooks.denoInstallHook)
      denoPackage
      diffutils
      zip
      jq
    ];

    DENO_DIR = denoDir;

    dontFixup = if binaryEntrypointPath != null then false else dontFixup;

    passthru = {
      inherit denoDeps;
    };

    meta = (args.meta or { }) // {
      platforms = args.meta.platforms or denoPackage.meta.platforms;
    };
  }
)
