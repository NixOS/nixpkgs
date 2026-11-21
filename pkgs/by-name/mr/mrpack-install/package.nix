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
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "nothub";
    repo = "mrpack-install";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VoGUWN1AZRXGl/4MjoC0vNN2saWuOCS++Wl2M4zda+w=";
  };

  patches = [
    # Only the server command needs the latest Minecraft version, but every command looked it up,
    # so shell completions can't be generated without network access
    # https://github.com/nothub/mrpack-install/pull/138
    ./fix-offline-commands.patch
  ];

  vendorHash = "sha256-cmVqOA1rKa7guwW0GEM4TLpreOVh8p7vI/z8SIsxtdI=";

  excludedPackages = [
    # Separate Go module
    "e2e"
    # Upstream's release helpers
    "tools"
  ];

  ldflags = [
    "-s"
    "-X github.com/nothub/mrpack-install/internal/buildinfo.version=${finalAttrs.version}"
    "-X github.com/nothub/mrpack-install/internal/buildinfo.date=1970-01-01T00:00:00Z"
  ];

  # Tests serve their fixtures from local HTTP servers
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = lib.optionals stdenv.hostPlatform.isDarwin [
        # sendfile(2) does not work with __darwinAllowLocalNetworking, see NixOS/nix#16632
        "TestFetchMetadata"
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
