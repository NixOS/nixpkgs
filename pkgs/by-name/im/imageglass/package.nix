{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  patchelf,

  # Avalonia UI
  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,
  fontconfig,
}:
buildDotnetModule rec {
  pname = "imageglass";

  version = "10.0.0.314-beta-1";

  src = fetchFromGitHub {
    owner = "d2phap";
    repo = "ImageGlass";
    tag = version;
    hash = "sha256-nVfMuJ2zXviZ585TaG3Kj7+GjZ+eJwbh51tBFBGGW/M=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  nugetDeps = ./deps.json;

  preConfigure = ''
    cd v10
  '';

  projectFile = [
    (
      if stdenv.hostPlatform.isLinux then
        "ImageGlass.Linux/ImageGlass.Linux.csproj"
      else if stdenv.hostPlatform.isDarwin then
        "ImageGlass.Mac/ImageGlass.Mac.csproj"
      else
        "ImageGlass.Win32/ImageGlass.Win32.csproj"
    )
  ];

  executables = [ "ImageGlass" ];

  dotnetFlags = [
    "-p:DisableUpdateDetection=true"
    "-p:AvaloniaUseCompiledBindingsByDefault=true"
    "-p:AVALONIA_BUILDTASK_DISABLE=true"
  ];

  dotnetRestoreFlags = [
    "--ignore-failed-sources"
  ];

  nativeBuildInputs = [
    patchelf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  # Avalonia requires these libraries dlopen-ed at runtime on Linux
  runtimeDeps = lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "ImageGlass";
      exec = "ImageGlass %U";
      icon = "imageglass";
      desktopName = "ImageGlass";
      categories = [
        "Graphics"
        "Viewer"
        "2DGraphics"
        "RasterGraphics"
      ];
      terminal = false;
      comment = meta.description;
      mimeTypes = [
        "image/jpeg"
        "image/png"
        "image/gif"
        "image/webp"
        "image/svg+xml"
        "image/jxl"
        "image/heic"
        "image/avif"
      ];
    })
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      if [ -f "assets/Logo512.png" ]; then
        install -Dm644 assets/Logo512.png "$out/share/icons/hicolor/512x512/apps/imageglass.png"
      elif [ -f "assets/Logo.svg" ]; then
        install -Dm644 assets/Logo.svg "$out/share/icons/hicolor/scalable/apps/imageglass.svg"
      fi
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications/ImageGlass.app/Contents/Resources"
      cp assets/Logo.icns "$out/Applications/ImageGlass.app/Contents/Resources/ImageGlass.icns"
      cat > "$out/Applications/ImageGlass.app/Contents/Info.plist" <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>ImageGlass</string>
        <key>CFBundleIconFile</key>
        <string>ImageGlass</string>
        <key>CFBundleIdentifier</key>
        <string>org.imageglass.ImageGlass</string>
        <key>CFBundleName</key>
        <string>ImageGlass</string>
        <key>CFBundleVersion</key>
        <string>${version}</string>
        <key>CFBundleShortVersionString</key>
        <string>${version}</string>
        <key>NSHighResolutionCapable</key>
        <true/>
      </dict>
      </plist>
      EOF
      ln -s "$out/bin/ImageGlass" "$out/Applications/ImageGlass.app/Contents/MacOS/ImageGlass"
    '';
  meta = {
    description = "A lightweight, versatile cross-platform image viewer";
    longDescription = ''
      ImageGlass is a lightweight software designed for seamless viewing of images
      in a clean and intuitive interface. With support for over 90 common image formats
      including WEBP, GIF, SVG, PNG, JXL, HEIC, and AVIF.
    '';
    homepage = "https://imageglass.org/";
    changelog = "https://github.com/d2phap/ImageGlass/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "ImageGlass";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
