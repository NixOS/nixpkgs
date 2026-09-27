{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  clang,

  icu,
  openssl,
  zlib,
  fontconfig,
  freetype,
  libx11,
  libice,
  libsm,
  libxi,
  libxcursor,
  libxext,
  libxrandr,
}:

buildDotnetModule (finalAttrs: {
  pname = "imageglass";
  version = "10.0.5.825";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "d2phap";
    repo = "ImageGlass";
    tag = finalAttrs.version;
    hash = "sha256-4A7gSAyaqjjRWe6Vp22gshxaHwPbX8+6YbBcl31e+yA=";
  };

  projectFile = "source/ImageGlass.Linux/ImageGlass.Linux.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  runtimeId = "linux-x64";
  selfContainedBuild = true;
  dotnetFlags = [ "-p:Platform=x64" ];

  executables = [ "ImageGlass" ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    clang
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    icu
    openssl
    zlib
    fontconfig
    freetype
    libx11
    libice
    libsm
    libxi
    libxcursor
    libxext
    libxrandr
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "imageglass";
      exec = "ImageGlass %F";
      icon = "imageglass";
      desktopName = "ImageGlass";
      genericName = "Image Viewer";
      categories = [
        "Graphics"
        "Viewer"
      ];
      mimeTypes = [
        "image/png"
        "image/jpeg"
        "image/webp"
        "image/gif"
      ];
    })
  ];

  postInstall = ''
    cp -r --no-preserve=mode $src/source/__assets/__app/. $out/lib/imageglass/
    rm -rf $out/lib/imageglass/_ext_icons

    install -Dm644 $src/source/__assets/logo_c.svg $out/share/icons/hicolor/scalable/apps/imageglass.svg
    install -Dm644 $src/source/__assets/logo_c_512.png $out/share/icons/hicolor/512x512/apps/imageglass.png
  '';

  meta = {
    description = "Lightweight, versatile image viewer";
    homepage = "https://imageglass.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ itgourmand ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ImageGlass";
  };
})
