{
  lib,
  stdenv,
  writeText,

  fetchFromGitHub,

  dotnetCorePackages,
  buildDotnetModule,

  ffmpeg-headless,

  vulkan-loader,
  openssl,
  libGL,
  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,

  makeDesktopItem,
  copyDesktopItems,

  nix-update-script,
}:
let
  inherit (dotnetCorePackages) fetchNupkg;

  buildInfo = {
    id = "NixOS";
    name = "for NixOS";
  };

  appSettings = writeText "appsettings.json" (
    lib.strings.toJSON {
      PixiEditorApiUrl = "https://auth.pixieditor.net";
      PixiEditorApiKey = "waIvElX0fPqaxnyD7Rh1SSEvdq8qfKUs";
      AnalyticsUrl = "https://api.pixieditor.net/analytics/";
    }
  );
in
buildDotnetModule (finalAttrs: {
  pname = "pixieditor";
  version = "2.0.1.18";

  src = fetchFromGitHub {
    owner = "PixiEditor";
    repo = "PixiEditor";
    tag = finalAttrs.version;
    hash = "sha256-mGgFr7K9/vs7g6yugmw2QR+PG2/itb048Su4AdkzBNc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace ./src/PixiEditor/Helpers/VersionHelpers.cs \
      --replace-fail 'builder.Append(" Release Build");' 'builder.Append(" ${buildInfo.name}");' \
      --replace-fail 'return "Release";' 'return "${buildInfo.id}";';

    substituteInPlace ./src/PixiEditor/Models/ExceptionHandling/CrashReport.cs \
      --replace-fail 'ShellExecute(fileName,' 'ShellExecute("${placeholder "out"}/bin/pixieditor",';

    rm -rf ./src/PixiEditor.AnimationRenderer.FFmpeg/ThirdParty/{Linux,Macos,Windows}/*
    substituteInPlace ./src/PixiEditor.AnimationRenderer.FFmpeg/FFMpegRenderer.cs \
      --replace-fail 'new FFOptions() { BinaryFolder = binaryPath }' 'new FFOptions() { BinaryFolder = "${ffmpeg-headless}/bin" }' \
      --replace-fail 'MakeExecutableIfNeeded(binaryPath);' ' ';
  '';

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    (fetchNupkg {
      pname = "protobuf-net.protogen";
      version = "3.2.52";
      hash = "sha256-sKVCXtd5qD86D2FOgjMXh37P6IrcmqmaoJregAhLFGY=";
    })
  ];

  nugetDeps = ./deps.json;
  linkNugetPackages = true;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetFlags =
    lib.optionals stdenv.hostPlatform.isx86_64 [ "-p:Runtimeidentifier=linux-x64" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "-p:Runtimeidentifier=linux-arm64" ];

  buildType = "ReleaseNoUpdate";
  projectFile = [
    "src/PixiEditor.Desktop/PixiEditor.Desktop.csproj"
    "src/PixiEditor/PixiEditor.csproj"
    "src/PixiEditor.Linux/PixiEditor.Linux.csproj"
    "src/PixiEditor.Platform.Standalone/PixiEditor.Platform.Standalone.csproj"
  ];
  executables = [ "PixiEditor.Desktop" ];

  runtimeDeps = [
    vulkan-loader
    openssl
    libGL
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "pixieditor";
      type = "Application";
      desktopName = "PixiEditor";
      genericName = "2D Editor";
      comment = finalAttrs.meta.description;
      icon = "pixieditor";
      exec = "pixieditor %f";
      tryExec = "pixieditor";
      startupWMClass = "pixieditor";
      terminal = false;
      categories = [
        "Graphics"
        "2DGraphics"
        "RasterGraphics"
        "VectorGraphics"
      ];
      keywords = [
        "editor"
        "image"
        "2d"
        "graphics"
        "design"
        "vector"
        "raster"
      ];
      mimeTypes = [
        "application/x-pixieditor"
      ];
      extraConfig.SingleMainWindow = "true";
    })
  ];

  postConfigure = ''
    dotnet build -t:InstallProtogen \
      src/PixiEditor.Extensions.CommonApi/PixiEditor.Extensions.CommonApi.csproj
  '';

  postInstall = ''
    install -Dm644 ${appSettings} $out/lib/pixieditor/appsettings.json;

    install -Dm644 ${./mimeinfo.xml} $out/share/mime/packages/pixieditor.xml;

    install -Dm644 src/PixiEditor/Images/PixiEditorLogo.svg \
      $out/share/icons/hicolor/scalable/apps/pixieditor.svg;
  '';

  postFixup = ''
    mv $out/bin/PixiEditor.Desktop $out/bin/pixieditor
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Universal editor for all your 2D needs";
    longDescription = ''
      PixiEditor is a universal 2D platform that aims to provide you with tools and features for all your 2D needs.
      Create beautiful sprites for your games, animations, edit images, create logos. All packed in an eye-friendly dark theme
    '';
    homepage = "https://pixieditor.com";
    changelog = "https://github.com/PixiEditor/PixiEditor/releases/tag/${finalAttrs.version}";
    mainProgram = "pixieditor";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
