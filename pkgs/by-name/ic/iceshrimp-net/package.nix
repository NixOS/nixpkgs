{
  lib,
  stdenvNoCC,
  fetchgit,
  buildDotnetModule,
  dotnetCorePackages,
  vips,
  openjpeg,
  python315,
  enableVIPS ? true,
  enableAOT ? false,
}:
let
  inherit (dotnetCorePackages) fetchNupkg;

  targetRID =
    {
      aarch64-linux = "linux-arm64";
      x86_64-linux = "linux-x64";
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
buildDotnetModule rec {
  pname = "iceshrimp-net";
  version = "2026.1.1-beta";

  src = fetchgit {
    url = "https://iceshrimp.dev/iceshrimp/Iceshrimp.NET";
    rev = "v${version}";
    hash = "sha256-HeLP9OprznxYks63pfmChs7TH+aad39Cm8DvrCIoQ8s=";
  };

  projectFile = "Iceshrimp.Backend/Iceshrimp.Backend.csproj";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  nugetDeps = ./deps.json;
  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = lib.optionals enableVIPS [
    vips
    openjpeg
  ];

  nativeBuildInputs = lib.optional enableAOT python315;

  dotnetFlags =
    lib.optionals enableVIPS [
      "-p:EnableLibVips=true"
      "-p:BundleNativeDeps=true"
    ]
    ++ lib.optionals enableAOT [
      "-p:EnableAOT=true"
    ];

  preConfigure = lib.optionalString enableAOT ''
    dotnet workload install wasm-tools
  '';

  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    dotnet build ${projectFile} \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:DeterministicSourcePaths=true \
      -p:OverwriteReadOnlyFiles=true \
      --configuration Release \
      --runtime ${targetRID} \
      ${lib.join " " dotnetFlags} \

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dotnet publish ${projectFile} \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:DeterministicSourcePaths=true \
      -p:OverwriteReadOnlyFiles=true \
      --no-build \
      --configuration Release \
      --runtime ${targetRID} \
      --output $out/lib/$pname \
      ${lib.join " " dotnetFlags}

    runHook postInstall
  '';

  meta = {
    description = "A decentralized and federated social networking service, implementing the ActivityPub standard.";
    homepage = "https://iceshrimp.dev";
    changelog = "https://iceshrimp.dev/iceshrimp/iceshrimp.NET/releases/tag/v${version}";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.linux;
    mainProgram = "Iceshrimp.Backend";
    maintainers = [ lib.maintainers.twoneis ];
  };
}
