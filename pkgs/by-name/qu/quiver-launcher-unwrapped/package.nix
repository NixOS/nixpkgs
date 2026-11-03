{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  desktopToDarwinBundle,
  dotnetCorePackages,
  flatpak,
  glib,
  libGL,
  libxext,
  libxi,
  libxrandr,
  nix-update-script,
  procps,
  sdl3,
  util-linux,
  versionCheckHook,
  which,
  writableTmpDirAsHomeHook,
  withFlatpak ? stdenv.hostPlatform.isLinux,
}:

buildDotnetModule (finalAttrs: {
  pname = "quiver-launcher-unwrapped";
  version = "3.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tgeorgiadis";
    repo = "quiver-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nk/lVJyps2az8yLOqihZd0I44Hkrdl70+FSfSGTQSYI=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  projectFile = "QuiverLauncher.Desktop/QuiverLauncher.Desktop.csproj";
  testProjectFile = "QuiverLauncher.Tests/QuiverLauncher.Tests.csproj";
  nugetDeps = ./deps.json;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  doCheck = stdenv.hostPlatform.isLinux;
  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # For test: HostGameSessionTests.Host_session_waits_for_remaining_children_and_preserves_literal_arguments
    procps
    util-linux
  ];

  disabledTests = [
    # reads the .csproj files
    "QuiverLauncher.Tests.ReleasePackagingTests.Project_references_velopack_and_does_not_copy_apps_json"
    # runs dotnet publish on the desktop .csproj
    "QuiverLauncher.Tests.ReleasePackagingTests.Publish_output_does_not_include_apps_json"
    # reads upstream .github/workflows/dotnet-desktop.yml file
    "QuiverLauncher.Tests.ReleasePackagingTests.Release_workflow_does_not_bundle_apps_json_in_platform_archives"
    # copies /bin/sh to run a script
    "QuiverLauncher.Tests.LinuxLauncherScriptTests.Linux_launch_and_shortcuts_use_saved_wrapper_natively"
  ];

  runtimeDeps =
    lib.optionals stdenv.hostPlatform.isLinux [
      glib # needed by Linux_desktop_launcher_runs_the_game_with_literal_arguments_and_working_directory
      libGL
      libxext
      libxi
      libxrandr
      sdl3
    ]
    ++ lib.optional withFlatpak flatpak;

  executables = [ "QuiverLauncher" ];

  makeWrapperArgs = [
    "--set"
    "QuiverLauncher_SKIP_UPDATES"
    "1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      procps
      util-linux
      which
    ])
  ];

  postInstall = ''
    ln -sf ${lib.getLib sdl3}/lib/libSDL3${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/${finalAttrs.pname}

    install -Dm644 packaging/flatpak/io.github.tgeorgiadis.QuiverLauncher.desktop -t $out/share/applications
    install -Dm644 packaging/flatpak/io.github.tgeorgiadis.QuiverLauncher.metainfo.xml -t $out/share/metainfo
    install -Dm644 Assets/quiver-icon.png $out/share/icons/hicolor/256x256/apps/io.github.tgeorgiadis.QuiverLauncher.png

    substituteInPlace $out/share/applications/io.github.tgeorgiadis.QuiverLauncher.desktop \
      --replace-fail "Exec=quiver-launcher" "Exec=QuiverLauncher"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--help";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Launcher for downloading, installing, and running apps from GitHub and GitLab releases";
    longDescription = ''
      Quiver Launcher downloads, installs, and updates apps and game ports
      from GitHub and GitLab releases. It keeps a personal library with tag
      filters, browses the quiverlauncher.com catalog, manages mods from
      Thunderstore and GameBanana, and runs Windows-only releases on Linux
      through Wine, Proton, or a custom command.

      On Linux, use the `quiver-launcher` package. AppImages
      cannot mount themselves inside it, so on NixOS enable
      `programs.appimage.binfmt = true;` to run them through appimage-run.
    '';
    homepage = "https://quiverlauncher.com";
    changelog = "https://github.com/tgeorgiadis/quiver-launcher/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "QuiverLauncher";
  };
})
