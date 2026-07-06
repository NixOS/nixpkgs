{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  fontconfig,
  freetype,
  expat,
  libx11,
  libice,
  libsm,
  libxi,
  libxcursor,
  libxext,
  libxrandr,
  libxtst,
  libglvnd,
  wayland,
  libxkbcommon,
  glib,
  icu,
  openssl,
  zlib,
}:

buildDotnetModule rec {
  pname = "crossmacro";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alper-han";
    repo = "CrossMacro";
    tag = "v${version}";
    hash = "sha256-M+Mat8pYeUyzomuvDdHdTHbyquTBDqrHHObVixTM3is=";
  };

  projectFile = "src/CrossMacro.UI.Linux/CrossMacro.UI.Linux.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  executables = [ "CrossMacro.UI" ];
  buildType = "Release";

  dotnetFlags = [
    "-p:SelfContained=false"
    "-p:Version=${version}"
  ];

  runtimeDeps = [
    zlib
    icu
    openssl
    fontconfig
    freetype
    expat
    libx11
    libice
    libsm
    libxi
    libxcursor
    libxext
    libxrandr
    libxtst
    glib
    libglvnd
    wayland
    libxkbcommon
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/man/crossmacro.1

    install -Dm644 scripts/assets/CrossMacro.desktop $out/share/applications/crossmacro.desktop

    for size in 16 32 48 64 128 256 512; do
      install -Dm644 src/CrossMacro.UI/Assets/icons/''${size}x''${size}/apps/crossmacro.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/crossmacro.png
    done

    install -Dm644 scripts/assets/io.github.alper-han.CrossMacro.metainfo.xml \
      $out/share/metainfo/io.github.alper-han.CrossMacro.metainfo.xml

    mkdir -p $out/bin
    ln -sf $out/bin/CrossMacro.UI $out/bin/crossmacro
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform mouse and keyboard macro recorder and player";
    homepage = "https://github.com/alper-han/CrossMacro";
    changelog = "https://github.com/alper-han/CrossMacro/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "crossmacro";
    maintainers = with lib.maintainers; [ alper-han ];
  };
}
