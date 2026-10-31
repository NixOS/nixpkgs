{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,

  esbuild,
  freetype,
  krb5,
  libGL,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  net-tools,
  openssl,
  xdg-utils,
  zlib,
}:

buildDotnetModule (finalAttrs: {
  pname = "apps2samsung";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "Apps2Samsung";
    repo = "Apps2Samsung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fkYlCQDbLGyAqk3w9d/qey0kvKAlLhx7gba1h5wihgw=";
  };

  postPatch = ''
    # Use the native esbuild for every supported architecture and avoid shipping
    # upstream's prebuilt binaries for other platforms.
    substituteInPlace Apps2Samsung.Core/Core/EsbuildHelper.cs \
      --replace-fail 'PlatformService.GetEsbuildPath(Path.Combine(baseDir, "Assets", "esbuild"))' \
                     '"${lib.getExe esbuild}"' \
      --replace-fail 'EnsureExecutable(esbuildPath);' ""
    rm -r Jellyfin2Samsung-CrossOS/Assets/esbuild
  '';

  strictDeps = true;
  __structuredAttrs = true;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  projectFile = "Jellyfin2Samsung-CrossOS/Apps2Samsung.csproj";
  nugetDeps = ./deps.json;

  dotnetFlags = [
    "-p:DisableSelfUpdate=true"
    "-p:PublishSingleFile=false"
  ];

  executables = [ "Apps2Samsung" ];

  # icu, fontconfig and libICE/libSM/libX11 are already provided through the
  # dotnet runtime and the Avalonia/SkiaSharp NuGet overrides.
  runtimeDeps = lib.optionals stdenv.hostPlatform.isLinux [
    # .NET runtime: TLS and GSSAPI
    krb5
    openssl
    zlib

    # Skia / font rendering
    freetype
    libGL

    # Avalonia X11 backend
    libxcursor
    libxext
    libxi
    libxrandr
  ];

  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      # `arp`, used to resolve the MAC vendor of discovered devices
      net-tools
      # `xdg-open`, used by the "open logs folder" and release-page buttons
      xdg-utils
    ])
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm444 Jellyfin2Samsung-CrossOS/Assets/jelly2sams.png \
      $out/share/icons/hicolor/256x256/apps/apps2samsung.png
  '';

  # The executable wrappers are only created during fixup.
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mv "$out/bin/Apps2Samsung" "$out/bin/apps2samsung"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      appDir="$out/Applications/Apps2Samsung.app/Contents"
      mkdir -p "$appDir/MacOS" "$appDir/Resources"
      ln -s "$out/bin/Apps2Samsung" "$appDir/MacOS/Apps2Samsung"
      install -m444 Jellyfin2Samsung-CrossOS/Assets/jelly2sams.icns "$appDir/Resources/"

      # Match the minimum OS version and network permission in upstream's release workflow.
      substitute Jellyfin2Samsung-CrossOS/Info.plist "$appDir/Info.plist" \
        --replace-fail '<string>10.15</string>' '<string>11.0</string>' \
        --replace-fail '</dict>' '<key>CFBundleShortVersionString</key>
        <string>${finalAttrs.version}</string>
        <key>NSLocalNetworkUsageDescription</key>
        <string>Apps2Samsung scans your local network to find Samsung TVs in Developer Mode.</string>
      </dict>'
    '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "apps2samsung";
      desktopName = "Apps2Samsung";
      comment = "Install any app on Samsung TVs, projectors and smart monitors";
      exec = finalAttrs.meta.mainProgram;
      icon = "apps2samsung";
      categories = [
        "Utility"
        "Network"
      ];
      keywords = [
        "jellyfin"
        "samsung"
        "sideload"
        "tizen"
        "tv"
      ];
      startupNotify = true;
      startupWMClass = "Apps2Samsung";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sideload Jellyfin and other apps onto Samsung Tizen TVs, projectors and smart monitors";
    longDescription = ''
      Apps2Samsung (formerly Jellyfin2Samsung) side-loads applications onto Samsung
      devices running Tizen OS. It handles device detection, Samsung developer
      certificate provisioning and installation, so Tizen Studio or manual
      sideloading is not needed. Jellyfin, Moonlight, Moonfin, Litefin, the
      community package catalog and custom `.wgt` files are supported.

      The target device must have Developer Mode enabled.
    '';
    homepage = "https://github.com/Apps2Samsung/Apps2Samsung";
    changelog = "https://github.com/Apps2Samsung/Apps2Samsung/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      confused-engineer
      schembriaiden
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = if stdenv.hostPlatform.isLinux then "apps2samsung" else "Apps2Samsung";
  };
})
