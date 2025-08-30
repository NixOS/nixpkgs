{
  lib,
  buildDotnetModule,
  fetchFromGitea,
  dotnetCorePackages,
}:

# NOTE: Because of the way Iceshrimp is built (WebAssembly frontend/regular backend),
# the normal buildDotnetModule hooks do not work because they always set runtimeId and
# selfContainedBuild, which does not work with this kind of project.
# Therefore we manually override the buildPhase and installPhase with variants of the
# normal dotnet hooks.

buildDotnetModule {
  pname = "iceshrimp.net";
  version = "2025.1-beta5.patch3.security2";

  src = fetchFromGitea {
    domain = "iceshrimp.dev";
    owner = "iceshrimp";
    repo = "Iceshrimp.NET";
    forceFetchGit = true;
    rev = "5a8ddfdddb8a94e305c8c1b4a2998e2b97e2277e";
    hash = "sha256-85yaQ9rekyH/wVdrRJrfWjzi2aaevlUN7dQBtl/fdaE=";
  };

  nugetDeps = ./deps.json;

  projectFile = "Iceshrimp.Backend";

  configurePhase = ''
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    local -a projectFiles flags runtimeIds
    concatTo projectFiles dotnetProjectFiles dotnetTestProjectFiles
    concatTo flags dotnetFlags dotnetRestoreFlags
    concatTo runtimeIds dotnetRuntimeIds

    if [[ -z ''${enableParallelBuilding-} ]]; then
      flags+=(--disable-parallel)
    fi

    dotnetRestore() {
      local -r projectFile="''${1-}"
      for runtimeId in "''${runtimeIds[@]}"; do
        dotnet restore ''${1+"$projectFile"} \
               -p:ContinuousIntegrationBuild=true \
               -p:Deterministic=true \
               -p:NuGetAudit=false \
               "''${flags[@]}"
      done
    }

    if [[ -f .config/dotnet-tools.json || -f dotnet-tools.json ]]; then
      dotnet tool restore
    fi

    # dotnetGlobalTool is set in buildDotnetGlobalTool to patch dependencies but
    # avoid other project-specific logic. This is a hack, but the old behavior
    # is worse as it relied on a bug: setting projectFile to an empty string
    # made the hooks actually skip all project-specific logic. It’s hard to keep
    # backwards compatibility with this odd behavior now since we are using
    # arrays, so instead we just pass a variable to indicate that we don’t have
    # projects.
    if [[ -z ''${dotnetGlobalTool-} ]]; then
      if (( ''${#projectFiles[@]} == 0 )); then
        dotnetRestore
      fi

      local projectFile
      for projectFile in "''${projectFiles[@]}"; do
        dotnetRestore "$projectFile"
      done
    fi

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
  '';

  buildPhase = ''
    runHook preBuild

    concatTo flags dotnetFlags dotnetBuildFlags

    if [[ -n "''${enableParallelBuilding-}" ]]; then
      local -r maxCpuFlag="$NIX_BUILD_CORES"
      local -r parallelBuildFlag="true"
    else
      local -r maxCpuFlag="1"
      local -r parallelBuildFlag="false"
    fi

    if [[ -n ''${version-} ]]; then
      flags+=("-p:InformationalVersion=$version")
    fi

    if [[ -n ''${versionForDotnet-} ]]; then
      flags+=("-p:Version=$versionForDotnet")
    fi

    dotnet build \
      Iceshrimp.Backend \
      -maxcpucount:"$maxCpuFlag" \
      -p:BuildInParallel="$parallelBuildFlag" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:OverwriteReadOnlyFiles=true \
      --configuration "$dotnetBuildType" \
      --no-restore \
      "''${flags[@]}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    concatTo flags dotnetFlags
    concatTo installFlags dotnetInstallFlags

    if [[ -n "''${enableParallelBuilding-}" ]]; then
      local -r maxCpuFlag="$NIX_BUILD_CORES"
    else
      local -r maxCpuFlag="1"
    fi

    dotnet publish \
      --output $out/lib/$pname \
      Iceshrimp.Backend \
      -maxcpucount:"$maxCpuFlag" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:OverwriteReadOnlyFiles=true \
      --configuration "$dotnetBuildType" \
      --no-restore \
      --no-build \
      "''${flags[@]}" \
      "''${installFlags[@]}"

    runHook postInstall
  '';

  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  meta = {
    description = "Decentralized and federated social networking service, implementing the ActivityPub standard";
    homepage = "https://iceshrimp.dev";
    license = lib.licenses.eupl12;
    # Restrictive platforms setting because of the way we fiddle with runtimeIds
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ tmarkus ];
  };
}
