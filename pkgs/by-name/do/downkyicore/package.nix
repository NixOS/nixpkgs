{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  icoutils,
  aria2,
  ffmpeg,
  fontconfig,
  freetype,
  icu,
  krb5,
  openssl,
  zlib,
  lttng-ust_2_12,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  libice,
  libsm,
}:

buildDotnetModule (finalAttrs: {
  pname = "downkyicore";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "yaobiao131";
    repo = "downkyicore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1APolFe2eq7aIZdg3Sl4DI/6lnvaAgX/GDcHx3M+o/I=";
  };

  projectFile = "DownKyi/DownKyi.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  executables = [ "DownKyi" ];

  nativeBuildInputs = [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    icoutils
  ];

  buildInputs = [
    aria2
    ffmpeg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    freetype
    icu
    krb5
    openssl
    zlib
    lttng-ust_2_12
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDeps = lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
    libice
    libsm
  ];

  postPatch = ''
    substituteInPlace DownKyi/DownKyi.csproj DownKyi.Core/DownKyi.Core.csproj \
      --replace-fail net6.0 net8.0
  '';

  makeWrapperArgs = [
    "--chdir"
    "${placeholder "out"}/lib/downkyicore"
  ];

  passthru.updateScript = nix-update-script { };

  # Provide system ffmpeg/aria2 binaries and license texts where the app expects them.
  postInstall = ''
    mkdir -p $out/lib/downkyicore/{aria2,ffmpeg}

    ln -s ${lib.getExe aria2} $out/lib/downkyicore/aria2/aria2c
    ln -s ${lib.getExe' ffmpeg "ffmpeg"} $out/lib/downkyicore/ffmpeg/ffmpeg
    ln -s ${lib.getExe' ffmpeg "ffprobe"} $out/lib/downkyicore/ffmpeg/ffprobe

    printf 'See https://github.com/aria2/aria2/blob/master/COPYING for aria2 licensing information.\n' > $out/lib/downkyicore/aria2_COPYING.txt
    printf 'See https://ffmpeg.org/legal.html for FFmpeg licensing information.\n' > $out/lib/downkyicore/FFmpeg_LICENSE.txt
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    icotool -x DownKyi/Resources/favicon.ico
    install -Dm444 \
      favicon_*_128x128x32.png \
      $out/share/icons/hicolor/128x128/apps/downkyicore.png
  '';
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app="$out/Applications/DownKyi.app"
    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

    cp $src/script/macos/Info.plist "$app/Contents/Info.plist"
    makeWrapper "$out/bin/DownKyi" "$app/Contents/MacOS/DownKyi"
    cp $src/script/macos/logo.icns "$app/Contents/Resources/logo.icns"
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "downkyicore";
      desktopName = "DownKyi";
      comment = "Cross-platform Bilibili downloader";
      exec = "DownKyi";
      icon = "downkyicore";
      categories = [
        "Network"
        "AudioVideo"
      ];
    })
  ];

  meta = {
    description = "Cross-platform Bilibili downloader built with Avalonia";
    homepage = "https://github.com/yaobiao131/downkyicore";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mio ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "DownKyi";
  };
})
