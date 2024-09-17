{
  writeShellScript,
  runtimeShell,
  nix,
  lib,
  substituteAll,
  nuget-to-nix,
  cacert,
  fetchNupkg,
  callPackage,
}:

{
  nugetDeps,
  overrideFetchAttrs ? x: { },
}:
fnOrAttrs: finalAttrs:
let
  attrs = if builtins.isFunction fnOrAttrs then fnOrAttrs finalAttrs else fnOrAttrs;

  deps =
    if (nugetDeps != null) then
      if lib.isDerivation nugetDeps then
        [ nugetDeps ]
      else if lib.isList nugetDeps then
        nugetDeps
      else
        assert (lib.isPath nugetDeps);
        callPackage nugetDeps { fetchNuGet = fetchNupkg; }
    else
      [ ];

  finalPackage = finalAttrs.finalPackage;

in
attrs
// {
  buildInputs = attrs.buildInputs or [ ] ++ deps;

  passthru =
    attrs.passthru or { }
    // {
      nugetDeps = deps;
    }
    // lib.optionalAttrs (nugetDeps == null || lib.isPath nugetDeps) rec {
      fetch-drv =
        let
          pkg' = finalPackage.overrideAttrs (old: {
            buildInputs = attrs.buildInputs or [ ];
            nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ cacert ];
            keepNugetConfig = true;
            dontBuild = true;
            doCheck = false;
            dontInstall = true;
            doInstallCheck = false;
            dontFixup = true;
            doDist = false;
          });
        in
        pkg'.overrideAttrs overrideFetchAttrs;
      fetch-deps =
        let
          drv = builtins.unsafeDiscardOutputDependency fetch-drv.drvPath;

          innerScript = substituteAll {
            src = ./fetch-deps.sh;
            isExecutable = true;
            inherit cacert;
            nugetToNix = nuget-to-nix;
          };

          defaultDepsFile =
            # Wire in the depsFile such that running the script with no args
            # runs it agains the correct deps file by default.
            # Note that toString is necessary here as it results in the path at
            # eval time (i.e. to the file in your local Nixpkgs checkout) rather
            # than the Nix store path of the path after it's been imported.
            if lib.isPath nugetDeps && !lib.isStorePath nugetDeps then
              toString nugetDeps
            else
              ''$(mktemp -t "${finalAttrs.pname or finalPackage.name}-deps-XXXXXX.nix")'';

        in
        writeShellScript "${finalPackage.name}-fetch-deps" ''
          set -eu

          echo 'fetching dependencies for' ${lib.escapeShellArg finalPackage.name} >&2

          # this needs to be before TMPDIR is changed, so the output isn't deleted
          # if it uses mktemp
          depsFile=$(realpath "''${1:-${lib.escapeShellArg defaultDepsFile}}")

          export TMPDIR
          TMPDIR=$(mktemp -d -t fetch-deps-${lib.escapeShellArg finalPackage.name}.XXXXXX)
          trap 'chmod -R +w "$TMPDIR" && rm -fr "$TMPDIR"' EXIT

          export NUGET_HTTP_CACHE_PATH=''${NUGET_HTTP_CACHE_PATH-~/.local/share/NuGet/v3-cache}

          HOME=$TMPDIR/home
          mkdir "$HOME"

          cd "$TMPDIR"

          NIX_BUILD_SHELL=${lib.escapeShellArg runtimeShell} ${nix}/bin/nix-shell \
            --pure --keep NUGET_HTTP_CACHE_PATH --run 'source '${lib.escapeShellArg innerScript}' '"''${depsFile@Q}" "${drv}"
        '';
    };
}
