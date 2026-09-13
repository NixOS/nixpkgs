{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  libiconv,
  ffmpeg_7,
  patchelf,
  pkg-config,
  llvm,
  clang,
  zlib,
  cargo,
  rustc,
  dbus,
  libx11,
  libxcb,
  libXrandr,
  libSM,
  libsecret,
  glib, # gsettings
  mesa-demos, # glxinfo
  xrandr,
  pciutils,
  gnugrep,
  gnused,
}:

buildDotnetModule (finalAttrs: {
  pname = "snapx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "SnapXL";
    repo = "SnapX";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z7uqvtM0Q0UZSHcfjWPZVEJ8HqmlqTNQdvetPNwwVpA=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  selfContainedBuild = true;

  nugetDeps = ./deps.json;

  projectFile = [
    "SnapX.CLI/SnapX.CLI.csproj"
    "SnapX.Avalonia/SnapX.Avalonia.csproj"
  ];

  executables = [
    "snapx"
    "snapx-ui"
  ];

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
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libSM
    libsecret
    libx11
    libxcb
    libXrandr
  ];

  runtimeDeps = [
    ffmpeg_7
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libSM
    libsecret
    libx11
    libxcb
    libXrandr
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        ffmpeg_7
        glib
        mesa-demos
        xrandr
        pciutils
        gnugrep
        gnused
      ]
    }"
  ];

  env = {
    HOME = "/build";
    SKIP_MACOS_VERSION_CHECK = "1";
    ELEVATION_NOT_NEEDED = "1";
    PKGTYPE = "NIXPKGS";
    ALLOW_DOTNET_DOWNLOAD = "0";
  };

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/usr/share
    cp -r packaging/usr/share/* $out/usr/share
  '';

  meta = with lib; {
    description = "Capture, share, and automate your screenshots (fork of ShareX)";
    longDescription = ''
      SnapX is a free, open-source, cross-platform tool that lets you capture or record
      any area of your screen and instantly share it with a single keypress.
      Upload images, videos, text, and more to multiple supported destinations.
    '';
    homepage = "https://github.com/SnapXL/SnapX";
    changelog = "https://github.com/SnapXL/SnapX/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    mainProgram = "snapx-ui";
    platforms = platforms.unix;
    maintainers = with maintainers; [ philocalyst ];
  };
})
