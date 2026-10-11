{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  installShellFiles,
  clang,
  autoPatchelfHook,
  nix-update-script,
  testers,
  desktop-file-utils,
  file,
  appstream,
  fontconfig,
  freetype,
  expat,
  libx11,
  libice,
  libsm,
  libxi,
  libxcursor,
  libxext,
  libxrandr,
  libxtst,
  libglvnd,
  wayland,
  libxkbcommon,
  glib,
  icu,
  openssl,
  zlib,
  pipewire,
}:

let
  isLinux = stdenv.hostPlatform.isLinux;
  isDarwin = stdenv.hostPlatform.isDarwin;
  commonLibs = [
    zlib
    icu
    openssl
  ];
  linuxLibs = [
    fontconfig
    freetype
    expat
    libx11
    libice
    libsm
    libxi
    libxcursor
    libxext
    libxrandr
    libxtst
    glib
    libglvnd
    wayland
    libxkbcommon
    pipewire
  ];
  runtimeLibs = map lib.getLib (commonLibs ++ lib.optionals isLinux linuxLibs);
  uiHostProject =
    if isDarwin then
      "src/CrossMacro.UI.MacOS/CrossMacro.UI.MacOS.csproj"
    else
      "src/CrossMacro.UI.Linux/CrossMacro.UI.Linux.csproj";
in
buildDotnetModule (finalAttrs: {
  pname = "crossmacro";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "alper-han";
    repo = "CrossMacro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JV3Fa7LVhts6TXOWL+0vnKxH1FbMSm/AELUgYUgVLco=";
  };

  projectFile = uiHostProject;
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null;

  # The upstream profile publishes a self-contained Native AOT binary without
  # a .NET apphost; keep the builder settings aligned with that contract.
  buildType = "Release";
  selfContainedBuild = true;
  useAppHost = false;
  executables = lib.optional isDarwin "CrossMacro.UI";
  dotnetFlags = [
    "-p:CrossMacroPublishProfile=native-aot"
    "-p:Version=${finalAttrs.version}"
  ];

  buildInputs = lib.optionals isLinux runtimeLibs;
  runtimeDependencies = lib.optionals isLinux runtimeLibs;

  nativeBuildInputs = [
    installShellFiles
    clang
  ]
  ++ lib.optionals isLinux [ autoPatchelfHook ];

  postInstall = ''
    installManPage docs/man/crossmacro.1
  ''
  + lib.optionalString isLinux ''
    install -Dm644 scripts/assets/CrossMacro.desktop \
      $out/share/applications/CrossMacro.desktop
    substituteInPlace $out/share/applications/CrossMacro.desktop \
      --replace-fail "Exec=crossmacro" \
        "Exec=$out/lib/crossmacro/CrossMacro.UI"

    for size in 16 32 48 64 128 256 512; do
      install -Dm644 \
        src/CrossMacro.UI/Assets/icons/$size"x"$size/apps/crossmacro.png \
        $out/share/icons/hicolor/$size"x"$size/apps/crossmacro.png
    done

    install -Dm644 \
      scripts/assets/io.github.alper_han.crossmacro.metainfo.xml \
      $out/share/metainfo/io.github.alper_han.crossmacro.metainfo.xml
    substituteInPlace $out/share/metainfo/io.github.alper_han.crossmacro.metainfo.xml \
      --replace-fail \
        '<launchable type="desktop-id">io.github.alper_han.crossmacro.desktop</launchable>' \
        '<launchable type="desktop-id">CrossMacro.desktop</launchable>'

    mkdir -p $out/bin
    ln -s ../lib/crossmacro/CrossMacro.UI $out/bin/CrossMacro.UI
    ln -s CrossMacro.UI $out/bin/crossmacro
  ''
  + lib.optionalString isDarwin ''
    mkdir -p $out/bin
    ln -s CrossMacro.UI $out/bin/crossmacro
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.runCommand {
        name = "crossmacro-test-version";
        nativeBuildInputs = [ finalAttrs.finalPackage ];
        script = ''
          test "$(crossmacro --version)" = "CrossMacro.UI v${finalAttrs.version}"
          touch "$out"
        '';
      };
    }
    // lib.optionalAttrs isLinux {
      desktop = testers.runCommand {
        name = "crossmacro-desktop-contract";
        nativeBuildInputs = [
          appstream
          desktop-file-utils
          file
        ];
        script = ''
          desktop=${finalAttrs.finalPackage}/share/applications/CrossMacro.desktop
          executable=${finalAttrs.finalPackage}/lib/crossmacro/CrossMacro.UI

          desktop-file-validate "$desktop"
          grep -Fx "Exec=$executable" "$desktop"
          grep -Fx "X-KDE-DBUS-Restricted-Interfaces=org.kde.KWin.ScreenShot2" "$desktop"
          test -x "$executable"
          file -L "$executable" | grep -q ELF
          env -i "$executable" --version | grep -Fx "CrossMacro.UI v${finalAttrs.version}"
          test "$(readlink -f ${finalAttrs.finalPackage}/bin/crossmacro)" = "$(readlink -f "$executable")"
          test "$(readlink -f ${finalAttrs.finalPackage}/bin/CrossMacro.UI)" = "$(readlink -f "$executable")"
          appstreamcli validate-tree --no-net ${finalAttrs.finalPackage}

          touch "$out"
        '';
      };
    };
  };

  meta = {
    description = "Mouse and keyboard macro recorder and automation tool";
    homepage = "https://github.com/alper-han/CrossMacro";
    changelog = "https://github.com/alper-han/CrossMacro/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "crossmacro";
    maintainers = with lib.maintainers; [ alper-han ];
  };
})
