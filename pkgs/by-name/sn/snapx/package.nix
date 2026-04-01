{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  libiconv,
  makeDesktopItem,
  ffmpeg_7,
  patchelf,
  pkg-config,
  llvm,
  clang,
  zlib,
  cargo,
  rustc,
  dbus,
  xorg,
  libSM,
  libsecret,
}:

buildDotnetModule rec {
  pname = "snapx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "SnapXL";
    repo = "SnapX";
    rev = "v${version}";
    hash = "sha256-Z7uqvtM0Q0UZSHcfjWPZVEJ8HqmlqTNQdvetPNwwVpA=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  nugetDeps = ./deps.json;

  projectFile = [ "SnapX.Avalonia/SnapX.Avalonia.csproj" ];

  executables = [ "snapx-ui" ];

  dotnetFlags = [
    "-p:AvaloniaDisableTelemetry=true"
  ];

  nativeBuildInputs = [
    libiconv
    pkg-config
    patchelf
    llvm
    clang
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libSM
    libsecret
    xorg.libX11
    xorg.libxcb
    xorg.libXrandr
  ];

  runtimeDeps = [
    ffmpeg_7
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libSM
    libsecret
    xorg.libX11
    xorg.libxcb
    xorg.libXrandr
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ ffmpeg_7 ]}"
  ];

  env = {
    HOME = "/build";
    SKIP_MACOS_VERSION_CHECK = "1";
    ELEVATION_NOT_NEEDED = "1";
    PKGTYPE = "NIXPKGS";
    ALLOW_DOTNET_DOWNLOAD = "0";
  };

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "SnapX";
      exec = "snapx-ui";
      icon = "snapx";
      desktopName = "SnapX";
      categories = [
        "Utility"
        "Graphics"
        "2DGraphics"
      ];
      terminal = false;
      comment = meta.description;
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 SnapX.Avalonia/Assets/SnapX_Icon.ico $out/share/icons/hicolor/512x512/apps/snapx.png
  '';

  meta = with lib; {
    description = "Capture, share, and automate your screenshots (fork of ShareX)";
    longDescription = ''
      SnapX is a free, open-source, cross-platform tool that lets you capture or record
      any area of your screen and instantly share it with a single keypress.
      Upload images, videos, text, and more to multiple supported destinations.
    '';
    homepage = "https://github.com/SnapXL/SnapX";
    changelog = "https://github.com/SnapXL/SnapX/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    mainProgram = "snapx-ui";
    platforms = platforms.unix;
    maintainers = with maintainers; [ philocalyst ];
  };
}
