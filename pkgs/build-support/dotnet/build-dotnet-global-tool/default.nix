{
  buildDotnetModule,
  emptyDirectory,
  fetchNupkg,
  dotnet-sdk,
  lib,
}:

fnOrAttrs:

buildDotnetModule (
  finalAttrs:
  (
    {
      pname,
      version,
      # Name of the nuget package to install, if different from pname
      nugetName ? pname,
      # Hash of the nuget package to install, will be given on first build
      # nugetHash uses SRI hash and should be preferred
      nugetHash ? "",
      nugetSha256 ? "",
      # Additional nuget deps needed by the tool package
      nugetDeps ? (_: [ ]),
      # Executables to wrap into `$out/bin`, same as in `buildDotnetModule`, but with
      # a default of `pname` instead of null, to avoid auto-wrapping everything
      executables ? pname,
      # The dotnet runtime to use, dotnet tools need a full SDK to function
      dotnet-runtime ? dotnet-sdk,
      ...
    }@args:
    let
      nupkg = fetchNupkg {
        pname = nugetName;
        inherit version;
        sha256 = nugetSha256;
        hash = nugetHash;
        installable = true;
      };
    in
    args
    // {
      inherit
        pname
        version
        dotnet-runtime
        executables
        ;

      src = emptyDirectory;

      buildInputs = [ nupkg ];

      dotnetGlobalTool = true;

      useDotnetFromEnv = true;

      dontBuild = true;

      installPhase = ''
        runHook preInstall

        dotnet tool install --tool-path $out/lib/${pname} ${nugetName}

        # remove files that contain nix store paths to temp nuget sources we made
        find $out -name 'project.assets.json' -delete
        find $out -name '.nupkg.metadata' -delete

        runHook postInstall
      '';

      passthru = {
        updateScript = ./update.sh;
        nupkg = nupkg;
      } // args.passthru or { };
    }
  )
    (if lib.isFunction fnOrAttrs then fnOrAttrs finalAttrs else fnOrAttrs)
)
