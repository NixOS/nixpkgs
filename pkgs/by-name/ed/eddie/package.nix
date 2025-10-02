{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,

  gcc,
  makeWrapper,
  msbuild,
  pkg-config,

  curl,
  gtk3,
  libayatana-appindicator,

  openssh,
  openvpn,
  stunnel,

  gtk2,
  libayatana-indicator,

  mono,

  versionCheckHook,

  eddie,
  testers,
}:

buildDotnetModule (finalAttrs: {
  pname = "eddie";
  version = "2.24.6";

  src = fetchFromGitHub {
    owner = "AirVPN";
    repo = "Eddie";
    tag = finalAttrs.version;
    hash = "sha256-XSLxjF2k9cw+cx6KzFIQHtjDWqLT2V49KRw+oIyxM5M=";
  };

  patches = [
    ./dont-set-rpath-in-eddie-tray.patch
    ./remove-the-postbuild-from-the-project-file.patch
  ];

  projectFile = [ "src/App.CLI.Linux/App.CLI.Linux.net8.csproj" ];
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = [
    gcc
    makeWrapper
    msbuild
    pkg-config
  ];

  buildInputs = [
    curl
    gtk3
    libayatana-appindicator
  ];

  nativeRuntimeInputs = lib.makeBinPath [
    openssh
    openvpn
    stunnel
  ];

  runtimeInputs = lib.makeLibraryPath [
    gtk2
    gtk3
    libayatana-indicator
  ];

  makeWrapperArgs = [
    "--add-flags \"--path.resources=${placeholder "out"}/share/eddie-ui\""
    "--prefix PATH : ${finalAttrs.nativeRuntimeInputs}"
  ];

  executables = [ "eddie-cli" ];

  postPatch = ''
    patchShebangs src
  '';

  postBuild = ''
    src/App.CLI.Linux.Elevated/build.sh Release
    src/Lib.Platform.Linux.Native/build.sh Release
    src/App.Forms.Linux.Tray/build.sh Release

    msbuild \
      -v:minimal \
      -p:Configuration=Release \
      -p:TargetFrameworkVersion=v4.8 \
      -p:DefineConstants="EDDIEMONO4LINUX" \
      src/App.Forms.Linux/App.Forms.Linux.sln
  '';

  postInstall = ''
    mkdir -p $out/lib/eddie-ui
    mkdir -p $out/share/{applications,eddie-ui}

    cp src/App.CLI.Linux.Elevated/bin/eddie-cli-elevated $out/lib/eddie-ui
    cp src/Lib.Platform.Linux.Native/bin/libLib.Platform.Linux.Native.so $out/lib/eddie-ui
    cp src/App.Forms.Linux.Tray/bin/eddie-tray $out/lib/eddie-ui

    ln -s $out/lib/eddie-ui/eddie-cli-elevated $out/lib/eddie/eddie-cli-elevated
    ln -s $out/lib/eddie-ui/libLib.Platform.Linux.Native.so $out/lib/eddie/Lib.Platform.Linux.Native.so

    cp -r src/App.Forms.Linux/bin/*/Release/* $out/lib/eddie-ui
    chmod +x $out/lib/eddie-ui/App.Forms.Linux.exe

    cp -r resources/* $out/share/eddie-ui
    cp -r repository/linux_arch/bundle/eddie-ui/usr/share/{applications,pixmaps,polkit-1} $out/share

    substituteInPlace \
      $out/share/{applications/eddie-ui.desktop,polkit-1/actions/org.airvpn.eddie.ui.elevated.policy} \
      --replace-fail /usr $out

    makeWrapper "${mono}/bin/mono" $out/bin/eddie-ui \
      --add-flags $out/lib/eddie-ui/App.Forms.Linux.exe \
      --prefix LD_LIBRARY_PATH : ${finalAttrs.runtimeInputs} \
      ''${makeWrapperArgs[@]}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/eddie-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      package = eddie;
      command = "eddie-cli version.short";
    };
  };

  meta = {
    description = "AirVPN's OpenVPN and WireGuard wrapper";
    homepage = "https://eddie.website";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eddie-ui";
    maintainers = with lib.maintainers; [
      ryand56
    ];
    platforms = lib.platforms.linux;
  };
})
