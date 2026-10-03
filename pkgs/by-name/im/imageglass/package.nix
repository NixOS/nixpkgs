{
  lib,
  stdenv,
  buildDotnetModule,
  copyDesktopItems,
  dotnetCorePackages,
  fetchFromGitHub,
  makeDesktopItem,
  makeBinaryWrapper,
  makeWrapper,
  libicns,
  autoPatchelfHook,
  alsa-utils,
  fontconfig,
  freetype,
  glib,
  icu,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libice,
  libsm,
  libxcb,
  libxkbcommon,
  mesa,
  openssl,
  xdg-utils,
  zlib,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "imageglass";
  version = "10.0.5.825";

  src = fetchFromGitHub {
    owner = "d2phap";
    repo = "ImageGlass";
    tag = finalAttrs.version;
    hash = "sha256-4A7gSAyaqjjRWe6Vp22gshxaHwPbX8+6YbBcl31e+yA=";
  };

  projectFile =
    if stdenv.hostPlatform.isLinux then
      "source/ImageGlass.Linux/ImageGlass.Linux.csproj"
    else
      "source/ImageGlass.Mac/ImageGlass.Mac.csproj";

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  executables = [ "ImageGlass" ];
  selfContainedBuild = false;

  # The upstream projects default to trimmed, single-file NativeAOT builds.
  # Nix supplies the .NET runtime separately, so use a regular apphost here
  dotnetFlags = [
    "-p:Platform=${if stdenv.hostPlatform.isAarch64 then "ARM64" else "x64"}"
    "-p:PublishAot=false"
    "-p:PublishReadyToRun=false"
    "-p:PublishSingleFile=false"
    "-p:PublishTrimmed=false"
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libicns
      makeBinaryWrapper
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    map lib.getLib [
      stdenv.cc.cc
      fontconfig
      freetype
      icu
      libGL
      libx11
      libxcursor
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libice
      libsm
      libxcb
      libxkbcommon
      mesa
      openssl
      zlib
    ]
  );

  runtimeDeps = finalAttrs.buildInputs;

  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          alsa-utils
          glib
          xdg-utils
        ]
      }
    )
  '';

  postInstall = ''
    cp -r source/__assets/__app/. "$out/lib/imageglass/"
    rm -rf "$out/lib/imageglass/_ext_icons"
    rm -f "$out/lib/imageglass"/*.pdb
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 source/__assets/logo_c.svg \
      "$out/share/icons/hicolor/scalable/apps/imageglass.svg"
  '';

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
    name = "imageglass";
    exec = "imageglass %F";
    icon = "imageglass";
    desktopName = "ImageGlass";
    genericName = "Image viewer";
    comment = finalAttrs.meta.description;
    categories = [
      "Graphics"
      "Viewer"
    ];
    startupNotify = true;
    mimeTypes = [
      "image/jpeg"
      "image/png"
      "image/gif"
      "image/bmp"
      "image/tiff"
      "image/svg+xml"
      "image/webp"
      "image/avif"
      "image/heic"
      "image/heif"
      "image/x-icon"
      "image/vnd.microsoft.icon"
      "image/x-tga"
      "image/x-xcf"
      "image/x-portable-pixmap"
      "image/x-portable-graymap"
      "image/x-portable-bitmap"
      "image/x-portable-anymap"
      "image/x-exr"
      "image/x-radiance"
      "image/x-dds"
      "image/x-adobe-dng"
      "image/x-canon-cr2"
      "image/x-canon-cr3"
      "image/x-canon-crw"
      "image/x-nikon-nef"
      "image/x-nikon-nrw"
      "image/x-sony-arw"
      "image/x-sony-sr2"
      "image/x-sony-srf"
      "image/x-panasonic-raw"
      "image/x-panasonic-rw2"
      "image/x-olympus-orf"
      "image/x-fuji-raf"
      "image/x-kodak-dcr"
      "image/x-pentax-pef"
      "image/x-samsung-srw"
      "image/vnd.adobe.photoshop"
    ];
  });

  postFixup =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      app="$out/Applications/ImageGlass.app"
      mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

      cp "$src/source/__assets/mac/Info.plist" "$app/Contents/Info.plist"

      # The escaped dollar is required by substituteInPlace's Bash-backed
      substituteInPlace "$app/Contents/Info.plist" \
        --replace-quiet "\''${IG_VERSION}" "${finalAttrs.version}" \
        --replace-quiet "\''${IG_SHORT_VERSION}" "${lib.concatStringsSep "." (lib.take 3 (lib.splitVersion finalAttrs.version))}" \
        --replace-quiet "\''${IG_BUILD}" "${lib.last (lib.splitVersion finalAttrs.version)}"

      mv "$out/bin/ImageGlass" "$out/bin/.imageglass-wrapper"
      mv "$out/bin/.imageglass-wrapper" "$out/bin/imageglass"

      # The upstream ICNS has opaque white corners.
      ${lib.getExe' libicns "png2icns"} \
        "$app/Contents/Resources/logo.icns" "$src/source/__assets/logo_c_512.png"
      makeBinaryWrapper "$out/bin/imageglass" "$app/Contents/MacOS/ImageGlass"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      ln -s "$out/bin/ImageGlass" "$out/bin/imageglass"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, modern image viewer for 90+ image formats";
    longDescription = ''
      ImageGlass is a fast, modern and lightweight image viewer supporting more
      than 90 image formats, including common, raw camera and high-dynamic-range
      images.
    '';
    homepage = "https://imageglass.org";
    downloadPage = "https://github.com/d2phap/ImageGlass/releases";
    changelog = "https://github.com/d2phap/ImageGlass/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "imageglass";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = with lib.platforms; darwin ++ linux;
  };
})
