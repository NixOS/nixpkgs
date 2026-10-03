{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  sqlite,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  prefetch-yarn-deps,
  writers,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "chaptarr";
  version = "0.9.925";

  src = fetchFromGitHub {
    owner = "Chaptarr";
    repo = "chaptarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DCv+Bg6SiC1+LUtuipLfFIdsxmCPVTnCuc58M3OxQKk=";
  };

  postPatch = ''
    mv src/NuGet.config NuGet.Config
  '';

  installPath = "${placeholder "out"}/lib/chaptarr/bin";
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    nodejs
    yarn
    prefetch-yarn-deps
    fixup-yarn-lock
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-82ITzb6WkWtSMcBv1PRjrf0z8VA6lza7zO5ywxxkTG8=";
  };

  postConfigure = ''
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs --build node_modules
  '';
  postBuild = ''
    yarn --offline run build --env production
  '';
  postInstall =
    let
      packageInfo = writers.writeText "package_info" ''
        PackageVersion=${finalAttrs.version}
        PackageAuthor=[NixOS](https://nixos.org)
      '';
    in
    ''
      cp -a -- _output/UI "$out/lib/chaptarr/bin/UI"
      ln -s ${packageInfo} $out/lib/chaptarr/package_info
    '';

  nugetDeps = ./deps.json;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  doCheck = true;

  executables = [ "Chaptarr" ];

  projectFile = [
    "src/NzbDrone.Console/Chaptarr.Console.csproj"
    "src/NzbDrone.Mono/Chaptarr.Mono.csproj"
  ];

  testProjectFile = [
    "src/Chaptarr.Core.Test/Chaptarr.Core.Test.csproj"
  ];

  testFilters = [
    # No network in sandbox breaks these media cover tests
    "FullyQualifiedName!=Chaptarr.Core.Test.MediaCover.MediaCoverRenditionFixture.canonical_download_should_reject_mascot_and_persist_the_real_fallback_identity"
    "FullyQualifiedName!=Chaptarr.Core.Test.MediaCover.MediaCoverRenditionFixture.legacy_on_demand_mascot_file_should_be_rejected_without_a_network_request"
    "FullyQualifiedName!=Chaptarr.Core.Test.MediaCover.MediaCoverRenditionFixture.on_demand_author_image_should_reject_known_provider_placeholder"
    "FullyQualifiedName!=Chaptarr.Core.Test.MediaCover.MediaCoverRenditionFixture.rejected_preferred_photo_should_not_delete_a_verified_real_fallback"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net10.0"
    "--property:EnableAnalyzers=false"
    "--property:RuntimeIdentifier=${dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system}"
    "--property:SentryUploadSymbols=false"
    "--property:AssemblyVersion=${finalAttrs.version}"
    "--property:AssemblyConfiguration=main"
    "--property:Copyright=Copyright © 2026 Chaptarr contributors (GNU General Public v3)"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An audiobook and eBook collection manager";
    changelog = "https://github.com/Chaptarr/chaptarr/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/Chaptarr/chaptarr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lnk3 ];
    mainProgram = "Chaptarr";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
