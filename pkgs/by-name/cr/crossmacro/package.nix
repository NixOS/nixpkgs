{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  installShellFiles,
  clang,
  autoPatchelfHook,
  nix-update-script,
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

buildDotnetModule rec {
  pname = "crossmacro";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "alper-han";
    repo = "CrossMacro";
    tag = "v${version}";
    hash = "sha256-2L25A2OO2Ju6n1QlblNBtKva1PfbidFz/QESjLBVuSU=";
  };

  projectFile = "src/CrossMacro.UI.Linux/CrossMacro.UI.Linux.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null;

  executables = [ "CrossMacro.UI" ];
  buildType = "Release";
  selfContainedBuild = true;

  dotnetFlags = [
    "-p:PublishAot=true"
    "-p:PublishReadyToRun=false"
    "-p:OptimizationPreference=Speed"
    "-p:StripSymbols=true"
    "-p:IlcTrimMetadata=true"
    "-p:DebugType=None"
    "-p:DebugSymbols=false"
    "-p:Version=${version}"
  ];

  buildInputs = runtimeDeps;

  runtimeDeps = [
    zlib
    icu
    openssl
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

  nativeBuildInputs = [
    installShellFiles
    clang
    autoPatchelfHook
  ];

  postInstall = ''
    installManPage docs/man/crossmacro.1

    install -Dm644 scripts/assets/CrossMacro.desktop $out/share/applications/crossmacro.desktop
    substituteInPlace $out/share/applications/crossmacro.desktop \
      --replace-fail "Exec=crossmacro" "Exec=$out/lib/crossmacro/CrossMacro.UI"

    for size in 16 32 48 64 128 256 512; do
      install -Dm644 src/CrossMacro.UI/Assets/icons/''${size}x''${size}/apps/crossmacro.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/crossmacro.png
    done

    install -Dm644 scripts/assets/io.github.alper-han.CrossMacro.metainfo.xml \
      $out/share/metainfo/io.github.alper-han.CrossMacro.metainfo.xml
  '';

  postFixup = ''
    # Align wrapper and ELF paths so KWin's strict /proc/<pid>/exe check grants Wayland permissions.
    # Move the real ELF binary to .CrossMacro.UI-wrapped
    mv $out/lib/crossmacro/CrossMacro.UI \
       $out/lib/crossmacro/.CrossMacro.UI-wrapped

    # Move the buildDotnetModule wrapper from bin/ into lib/ so
    # its path matches what KWin resolves after unwrapping.
    mv $out/bin/CrossMacro.UI $out/lib/crossmacro/CrossMacro.UI

    # Update the wrapper's exec target to the renamed binary
    substituteInPlace $out/lib/crossmacro/CrossMacro.UI \
      --replace-fail \
        "\"$out/lib/crossmacro/CrossMacro.UI\"" \
        "\"$out/lib/crossmacro/.CrossMacro.UI-wrapped\""

    # Point bin/ entries at the lib/ wrapper
    rm -f $out/bin/crossmacro
    ln -s $out/lib/crossmacro/CrossMacro.UI $out/bin/CrossMacro.UI
    ln -s $out/bin/CrossMacro.UI $out/bin/crossmacro
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform mouse and keyboard macro recorder and player";
    homepage = "https://github.com/alper-han/CrossMacro";
    changelog = "https://github.com/alper-han/CrossMacro/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "crossmacro";
    maintainers = with lib.maintainers; [ alper-han ];
  };
}
