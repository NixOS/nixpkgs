{
  buildDotnetModule,
  fetchFromGitLab,
  dotnetCorePackages,
  lib,
  ffmpeg,
  curl-impersonate,
  libsodium,
  sqlite,
  libz,
  icu,
  openssl,
  libgbm,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxcb,
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
  grayjay-frontend,
  grayjay-libcurlshim,
}:
let
  version = "17";
  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "Grayjay.Desktop";
    tag = version;
    hash = "sha256-/oeoLXKewjYkCO7naZNOzauWm1OYDKnsxXY9EkI7fTM=";
    fetchSubmodules = true;
    fetchLFS = true;
  };
  getLibrary =
    pkg: libnm:
    "${lib.getLib pkg}/lib/lib${libnm}${pkg.drvAttrs.stdenv.hostPlatform.extensions.sharedLibrary}";
in
buildDotnetModule (finalAttrs: {
  pname = "grayjay";

  inherit version src;

  frontend = grayjay-frontend;

  __structuredAttrs = true;
  strictDeps = true;
  buildInputs = [
    openssl
    libgbm
    libgcc
    libx11
    gtk3
    glib
    alsa-lib
    nspr
    nss
    icu
    krb5
    curl-impersonate
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
    cp -r ${grayjay-frontend} Grayjay.ClientServer/wwwroot/web
  '';

  postInstall = ''
    ln -s /tmp/grayjay-launch $out/lib/grayjay/launch
    ln -s /tmp/grayjay-cef-launch $out/lib/grayjay/cef/launch

    # Unvendor most stuff
    rm -f $out/lib/grayjay/{Portable,ffmpeg,libcurl-impersonate.so,libcurlshim.so,libsodium.so,libe_sqlite3.so,FUTO.Updater.Client}
    ln -s ${lib.getExe ffmpeg} $out/lib/grayjay/ffmpeg
    ln -s ${getLibrary curl-impersonate "curl-impersonate"} $out/lib/grayjay/libcurl-impersonate.so
    ln -s ${getLibrary grayjay-libcurlshim "curlshim"} $out/lib/grayjay/libcurlshim.so
    ln -s ${getLibrary libsodium "sodium"} $out/lib/grayjay/libsodium.so
    ln -s ${getLibrary sqlite "sqlite3"} $out/lib/grayjay/libe_sqlite3.so

    # CEF is still vendored for now
    chmod +x $out/lib/grayjay/cef/dotcefnative

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

    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb

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
        "https://gitlab.futo.org/api/v4/projects/videostreaming%2FGrayjay%2EDesktop/repository/archive.tar.gz?sha=refs%2Ftags%2F10"
      ];
    })
    finalAttrs.passthru.fetch-deps
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
      pandapip1
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "Grayjay";
  };
})
