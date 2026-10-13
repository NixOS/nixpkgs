{
  lib,
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
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "Apps2Samsung";
    repo = "Apps2Samsung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H1cEWRIDUpMM4WvGseMgBUfMsWi2/BOgveeYW78b4sw=";
  };

  postPatch = ''
    # Treat the read-only store like the package-manager owned /usr and /opt, so the
    # built-in auto-updater stays disabled instead of trying to replace the store path.
    substituteInPlace Jellyfin2Samsung-CrossOS/Services/UpdaterService.cs \
      --replace-fail 'IsUnderDirectory(appDir, "/opt")' \
                     'IsUnderDirectory(appDir, "/opt") || IsUnderDirectory(appDir, "/nix/store")'
  '';

  strictDeps = true;
  __structuredAttrs = true;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  projectFile = "Jellyfin2Samsung-CrossOS/Apps2Samsung.csproj";
  nugetDeps = ./deps.json;

  dotnetFlags = [
    "-p:PublishSingleFile=false"
    "-p:SelfContained=false"
  ];

  executables = [ "Apps2Samsung" ];

  # icu, fontconfig and libICE/libSM/libX11 are already provided through the
  # dotnet runtime and the Avalonia/SkiaSharp NuGet overrides.
  runtimeDeps = [
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

  makeWrapperArgs = [
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

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    # Replace the bundled prebuilt esbuild (linux-x64 only, shipped without the
    # executable bit) with the one from nixpkgs. The app always looks it up under
    # linux-x64, whatever the architecture.
    rm -r $out/lib/apps2samsung/Assets/esbuild
    mkdir -p $out/lib/apps2samsung/Assets/esbuild/linux-x64
    ln -s ${lib.getExe esbuild} $out/lib/apps2samsung/Assets/esbuild/linux-x64/esbuild

    install -Dm444 Jellyfin2Samsung-CrossOS/Assets/jelly2sams.png \
      $out/share/icons/hicolor/256x256/apps/apps2samsung.png
  '';

  # The executable wrappers are only created during fixup.
  postFixup = ''
    ln -s $out/bin/Apps2Samsung $out/bin/apps2samsung
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "apps2samsung";
      desktopName = "Apps2Samsung";
      comment = "Install any app on Samsung TVs, projectors and smart monitors";
      exec = "apps2samsung";
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
    platforms = lib.platforms.linux;
    mainProgram = "apps2samsung";
  };
})
