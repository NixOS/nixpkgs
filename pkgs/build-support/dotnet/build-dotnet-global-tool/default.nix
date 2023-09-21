{ buildDotnetModule, emptyDirectory, mkNugetDeps, dotnet-sdk }:

{ pname
, version
  # Name of the nuget package to install, if different from pname
, nugetName ? pname
  # Hash of the nuget package to install, will be given on first build
, nugetSha256 ? ""
  # Additional nuget deps needed by the tool package
, nugetDeps ? (_: [])
  # Executables to wrap into `$out/bin`, same as in `buildDotnetModule`, but with
  # a default of `pname` instead of null, to avoid auto-wrapping everything
, executables ? pname
  # The dotnet runtime to use, dotnet tools need a full SDK to function
, dotnet-runtime ? dotnet-sdk
, ...
} @ args:

buildDotnetModule (args // {
  inherit pname version dotnet-runtime executables;

  src = emptyDirectory;

  nugetDeps = mkNugetDeps {
    name = pname;
    nugetDeps = { fetchNuGet }: [
      (fetchNuGet { pname = nugetName; inherit version; sha256 = nugetSha256; })
    ] ++ (nugetDeps fetchNuGet);
  };

  projectFile = "";

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
})
