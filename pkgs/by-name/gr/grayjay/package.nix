{
  buildDotnetModule,
  fetchFromGitLab,
  dotnetCorePackages,
  buildNpmPackage,
  lib,
  libz,
  icu,
  openssl,
  xorg,
  gtk3,
  glib,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  libdrm,
  expat,
  libxkbcommon,
  pango,
  cairo,
  udev,
  alsa-lib,
  mesa,
  libGL,
  libsecret,
  nix-update-script,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  libgcc,
  krb5,
  wrapGAppsHook3,
  _experimental-update-script-combinators,
}:
let
  version = "12";
  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "Grayjay.Desktop";
    tag = version;
    hash = "sha256-KVmik/YaJAr76QwXYRajXj7EVTJBs2NdbkDvIpLxlFc=";
    fetchSubmodules = true;
    fetchLFS = true;
  };
  frontend = buildNpmPackage {
    pname = "grayjay-frontend";
    inherit version src;

    sourceRoot = "source/Grayjay.Desktop.Web";

    npmBuildScript = "build";
    npmDepsHash = "sha256-3nPzQcDWhPCdLrPvwGY+K0t1OSxWrVwQ3hH7i0eynRU=";

    installPhase = ''
      runHook preInstall
      cp -r dist/ $out
      runHook postInstall
    '';
  };
in
buildDotnetModule (finalAttrs: {
  pname = "grayjay";

  inherit version src frontend;

  buildInputs = [
    openssl
    libgcc
    xorg.libX11
    gtk3
    glib
    alsa-lib
    mesa
    nspr
    nss
    icu
    krb5
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "Grayjay";
      exec = "Grayjay";
      icon = "grayjay";
      comment = "Cross platform media application for streaming and downloading media";
      desktopName = "Grayjay Desktop";
      categories = [ "Network" ];
    })
  ];

  projectFile = [
    "Grayjay.ClientServer/Grayjay.ClientServer.csproj"
    "Grayjay.Engine/Grayjay.Engine/Grayjay.Engine.csproj"
    "Grayjay.Desktop.CEF/Grayjay.Desktop.CEF.csproj"
    "FUTO.MDNS/FUTO.MDNS/FUTO.MDNS.csproj"
    "JustCef/DotCef.csproj"
  ];

  testProjectFile = [
    "Grayjay.Desktop.Tests/Grayjay.Desktop.Tests.csproj"
    "Grayjay.Engine/Grayjay.Engine.Tests/Grayjay.Engine.Tests.csproj"
  ];

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0 // {
    inherit
      (dotnetCorePackages.combinePackages [
        dotnetCorePackages.sdk_9_0
        dotnetCorePackages.sdk_8_0
      ])
      packages
      targetPackages
      ;
  };
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  executables = [ "Grayjay" ];

  preBuild = ''
    rm -r Grayjay.ClientServer/wwwroot/web
    cp -r ${frontend} Grayjay.ClientServer/wwwroot/web
  '';

  postInstall = ''
    chmod +x $out/lib/grayjay/cef/dotcefnative
    chmod +x $out/lib/grayjay/ffmpeg
    rm $out/lib/grayjay/Portable
    ln -s /tmp/grayjay-launch $out/lib/grayjay/launch
    ln -s /tmp/grayjay-cef-launch $out/lib/grayjay/cef/launch
    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/lib/grayjay/grayjay.png $out/share/icons/hicolor/scalable/apps/grayjay.png
  '';

  makeWrapperArgs = [
    "--chdir"
    "${placeholder "out"}/lib/grayjay"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  runtimeDeps = [
    libz

    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb

    dbus
    atk
    cups
    libdrm
    expat
    libxkbcommon
    pango
    cairo
    udev
    libGL
    libsecret
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
        "--url"
        "https://github.com/futo-org/Grayjay.Desktop"
      ];
    })
    (finalAttrs.passthru.fetch-deps)
  ];

  meta = {
    description = "Cross-platform application to stream and download content from various sources";
    longDescription = ''
      Grayjay is a cross-platform application that enables users to
      stream and download multimedia content from various online sources,
      most prominently YouTube.
      It also offers an extensible plugin API to create and import new
      integrations.
    '';
    homepage = "https://grayjay.app/desktop/";
    license = lib.licenses.sfl;
    maintainers = with lib.maintainers; [
      kruziikrel13
      samfundev
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Grayjay";
  };
})
