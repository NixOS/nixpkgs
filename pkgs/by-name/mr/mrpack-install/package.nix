{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  buildPackages,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "mrpack-install";
  version = "0.16.10";

  src = fetchFromGitHub {
    owner = "nothub";
    repo = "mrpack-install";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mTAXFK97t10imdICpg0UI4YLF744oscJqoOIBG5GEkc=";
  };

  vendorHash = "sha256-az+NpP/hCIq2IfO8Bmn/qG3JVypeDljJ0jWg6yT6hks=";

  ldflags = [
    "-s"
    "-X github.com/nothub/mrpack-install/buildinfo.Version=${finalAttrs.version}"
    "-X github.com/nothub/mrpack-install/buildinfo.date=1970-01-01T00:00:00Z"
  ];

  checkFlags =
    let
      skippedTests = [
        # Skip tests that require network access
        "TestFetchMetadata"
        "TestClient_VersionFromHash"
        "TestClient_GetDependencies"
        "TestClient_GetProjectVersions_Count"
        "TestClient_GetVersion"
        "TestClient_CheckProjectValidity_Slug"
        "Test_GetProject_404"
        "TestClient_GetProjects_Count"
        "TestClient_GetProjectVersions_Filter_NoResults"
        "Test_GetProject_Success"
        "TestClient_CheckProjectValidity_Id"
        "TestClient_GetLatestGameVersion"
        "TestClient_GetProjectVersions_Filter_Results"
        "TestClient_GetProjects_Slug"
        "TestClient_GetVersions"
        "TestGetPlayerUuid"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # /tmp is a symlink to /private/tmp on Darwin, breaking hardcoded path prefix checks
        "TestPathTraversalAbsolute"
        "TestPathTraversalRelative"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      mrpack-install = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/mrpack-install";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd mrpack-install \
        --bash <(${mrpack-install} completion bash) \
        --fish <(${mrpack-install} completion fish) \
        --zsh <(${mrpack-install} completion zsh)
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI application for installing Minecraft servers and Modrinth modpacks";
    homepage = "https://github.com/nothub/mrpack-install";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ encode42 ];
    mainProgram = "mrpack-install";
  };
})
