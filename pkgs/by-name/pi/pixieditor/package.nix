{
  lib,
  replaceVars,

  dotnetCorePackages,
  buildDotnetModule,
  buildDotnetGlobalTool,

  fetchFromGitHub,
  # fetchzip,

  ffmpeg-headless,

  vulkan-loader,
  libGL,
  xorg,
  openssl,

  makeDesktopItem,
  copyDesktopItems,
  librsvg,
}:
let
  protogen = buildDotnetGlobalTool {
    pname = "protogen";
    nugetName = "protobuf-net.Protogen";
    version = "3.2.42";
    nugetSha256 = "sha256-ADAkEfgzA7Po/pkV6wp7f7oyB8yvnJfOs7UriUDTgdc=";
  };
  # wasi-sdk-bin = fetchzip {
  #   url = "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-25/wasi-sdk-25.0-x86_64-linux.tar.gz";
  #   hash = "sha256-tKuGRXljb6mDZjG20NsmrL01A04uCWOCYn1njfLw53Y=";
  # };
in
buildDotnetModule (finalAttrs: {
  pname = "pixieditor";
  version = "2.0.0.99-dev";

  src = fetchFromGitHub {
    owner = "PixiEditor";
    repo = "PixiEditor";
    rev = "62b2a6cfd54d7b5ed549b293527be44a348d8974";
    hash = "sha256-Jkqd5GTDHlIxuGrgcEp75VRcDkwzxCntPOBj9i5Ryf8=";
    fetchSubmodules = true;
  };

  patches = [
    ./patches/0000-fix-protogen.patch
    ./patches/0001-set-build-id.patch
    ./patches/0002-nix-bin-path.patch
    (replaceVars ./patches/0003-use-sys-ffmpeg.patch {
      binaryPath = "${ffmpeg-headless}/bin";
    })
  ];
  postPatch = ''
    # ./patches/0002-nix-bin-path.patch
    substituteInPlace ./src/PixiEditor/Models/ExceptionHandling/CrashReport.cs \
      --replace-fail '@NIX_BIN_PATH@' '${placeholder "out"}/bin/pixieditor';
  '';

  nativeBuildInputs = [
    protogen
    librsvg
    copyDesktopItems
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.json;

  buildType = "ReleaseNoUpdate";
  projectFile = [
    "src/PixiEditor.Desktop/PixiEditor.Desktop.csproj"
    "src/PixiEditor.Linux/PixiEditor.Linux.csproj"
    "src/PixiEditor/PixiEditor.csproj"
  ];
  executables = [ "PixiEditor.Desktop" ];

  runtimeDeps = [
    vulkan-loader
    libGL
    xorg.libX11
    xorg.libICE
    xorg.libSM
    xorg.libXi
    xorg.libXcursor
    xorg.libXext
    xorg.libXrandr
    openssl
  ];

  # WASI_SDK_PATH = "${wasi-sdk-bin}";

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

  postInstall = ''
    # install mime type info
    install -Dm644 ${./resources/mimeinfo.xml} $out/share/mime/packages/pixieditor.xml

    # generate icons
    mkdir -p $out/share/icons/hicolor/{scalable,16x16,32x32,64x64,128x128,256x256,512x512}/apps
    install -Dm644 ${./resources/pixieditor.svg} $out/share/icons/hicolor/scalable/apps/pixieditor.svg
    for size in 16 32 64 128 256 512; do
      rsvg-convert \
        -w $size -h $size \
        ${./resources/pixieditor.svg} \
        -o $out/share/icons/hicolor/"$size"x"$size"/apps/pixieditor.png
    done
    mkdir -p $out/share/icons/pixmaps
    install -Dm644 $out/share/icons/hicolor/32x32/apps/pixieditor.png $out/share/icons/pixmaps/pixieditor.png
  '';

  postFixup = ''
    # rename main executable to pixieditor
    mv $out/bin/PixiEditor.Desktop $out/bin/pixieditor
  '';

  meta = {
    description = "Universal editor for all your 2D needs";
    longDescription = ''
      PixiEditor is a universal 2D platform that aims to provide you with tools and features for all your 2D needs.
      Create beautiful sprites for your games, animations, edit images, create logos. All packed in an eye-friendly dark theme
    '';
    homepage = "https://pixieditor.com";
    changelog = "https://forum.pixieditor.net/t/changelog-${
      lib.replaceString "." "-" (lib.removeSuffix "-dev" finalAttrs.version)
    }";
    mainProgram = "pixieditor";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux;
  };
})
