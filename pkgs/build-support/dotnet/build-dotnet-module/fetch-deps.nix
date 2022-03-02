{ lib
, buildDotnetModule
, dotnetValidateLockfileHook
, nuget-to-nix
, nugetSha256

, src
, name
, meta
, dotnet-sdk
, projectFile
, testProjectFile
, dotnetFlags
, dotnetRestoreFlags
, enableParallelBuilding
, sdkExclusions
} @ args:

buildDotnetModule rec {
  name = "${args.name}-nuget-lockfile";

  inherit src dotnet-sdk projectFile testProjectFile dotnetFlags dotnetRestoreFlags enableParallelBuilding;

  nativeBuildInputs = [ dotnetValidateLockfileHook ];

  generateLockfile = true;
  dontSetNugetSource = true;
  dontDotnetFixup = true;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  outputHashAlgo = "sha256";
  outputHashMode = "flat";
  outputHash = if (nugetSha256 != null)
    then nugetSha256
    else ""; # This needs to be set for networking, an empty string prints the "empty hash found" warning

  preConfigure = ''
    dotnetRestoreFlags+=(
      --packages "$HOME/nuget-pkgs"
    )

    echo "Evaluating and fetching Nuget dependencies"
  '';

  buildPhase = ''
    runHook preBuild

    NUGET_DEPS="$HOME/deps.nix"
    echo "Writing lockfile..."
    ${nuget-to-nix}/bin/nuget-to-nix "$HOME/nuget-pkgs" "${sdkExclusions}" > "$NUGET_DEPS"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp "$NUGET_DEPS" $out
    echo "Installed lockfile to: $out"

    runHook postInstall
  '';

  # This is the last phase that runs before we error out about the hash being wrong
  postFixup = lib.optionalString (nugetSha256 == null) ''
    echo "Please set nugetSha256 to the hash below!"
  '';

  meta = {
    description = "A lockfile containing the Nuget dependencies for ${name}";
    inherit (args.meta) maintainers platforms;
  };
}
