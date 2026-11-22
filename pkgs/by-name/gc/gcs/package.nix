{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  libGL,
  libx11,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gcs";
  version = "5.62.0";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u7hJ5/LPQFKeB8cuIUrvK57HGL0sh2ck6m1jMwf2YeY=";
  };

  vendorHash = "sha256-IJ9oKdlV8v8vyLUybilyEZcKXDSU0B67Qtw1x8zoOm0=";

  # flags are based on https://github.com/richardwilkes/gcs/blob/master/build.sh
  flags = [ "-a" ];
  ldflags = [
    "-s"
    "-w"
    "-X github.com/richardwilkes/toolbox/v2/xos.AppVersion=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # Scan the whole tree, including vendor/
        "TestGoSourcesHaveCopyrightHeader"
        "TestNoOrphanedGeneratedFiles"
        # Writes a stand-in hdiutil script with a /usr/bin/env shebang
        "TestExtractArchivesMountsDMG"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # FSEventStreamStart fails in the sandbox
        "TestLibrarySetPathAfterWatchFailsRestartsWatch"
        "TestLibrarySetPathWatchesAFolderHoldingAnotherLibrary"
        "TestLibraryWatchOutlivesTheWatchOfALibraryWithinIt"
        "TestLibraryWatchReportsPathsAsTheLibraryNamesThem"
        "TestRenameFolderMovesItsLibrariesAheadOfAWalk"
        "TestStopWatchesWithinReportsFoldersJustLetGoOf"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $GOPATH/bin/gcs -t $out/bin
    runHook postInstall
  '';

  # Loaded at runtime
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/gcs \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libx11
        ]
      }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/richardwilkes/gcs/releases/tag/v${finalAttrs.version}";
    description = "Stand-alone, interactive, character sheet editor for the GURPS 4th Edition roleplaying game system";
    homepage = "https://gurpscharactersheet.com/";
    license = lib.licenses.mpl20;
    mainProgram = "gcs";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
