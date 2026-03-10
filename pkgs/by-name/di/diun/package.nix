{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "diun";
  version = "4.31.0";

  src = fetchFromGitHub {
    owner = "crazy-max";
    repo = "diun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H05yZSH2rUrwM+ZR/PDCxXmrDkZ/Gd4RrpywGk5eW2A=";
  };
  vendorHash = null;

  # upstream disable CGO in release build
  # https://github.com/crazy-max/diun/blob/76c0fe99212adc58d6a3433bbcde1ffa9fb879c4/Dockerfile#L11
  env.CGO_ENABLED = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      # these tests require a network connection
      skippedTests = [
        "TestTags"
        "TestTagsWithDigest"
        "TestCompareDigest"
        "TestManifest"
        "TestManifestMultiUpdatedPlatform"
        "TestManifestMultiNotUpdatedPlatform"
        "TestManifestVariant"
        "TestManifestTaggedDigest"
        "TestManifestTaggedDigestUnknownTag"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    mv $out/bin/cmd $out/bin/diun
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI application to receive notifications when a Docker image is updated on a Docker registry";
    homepage = "https://crazymax.dev/diun";
    changelog = "https://crazymax.dev/diun/changelog";
    license = lib.licenses.mit;
    mainProgram = "diun";
    maintainers = with lib.maintainers; [ Sped0n ];
    platforms = lib.platforms.unix;
  };
})
