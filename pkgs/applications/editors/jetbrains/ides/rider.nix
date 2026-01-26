{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  patchSharedLibs,
  openssl,
  libxcrypt,
  lttng-ust_2_12,
  musl,
  libICE,
  libSM,
  libX11,
  dotnetCorePackages,
  libxcb-keysyms,
  expat,
  libxml2,
  xz,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1.tar.gz";
      hash = "sha256-uoQPfEjafxGM9Xqowi3zASDRbxdfvOO+xqZVkO2H8ug=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1-aarch64.tar.gz";
      hash = "sha256-GQgPzcSPoPdD7WCSe3GXWjxHi4BSlhYc/YoKosBMj1I=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1.dmg";
      hash = "sha256-rd2Bbb3xMOLvXn3BhNeoCH+L+/brpOMurSRSBppJYH0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1-aarch64.dmg";
      hash = "sha256-1wgDI0EpAPXTcnAjPlpMdzARxoU9YDHOH15jXHdRFCY=";
    };
  };
  # update-script-end: urls
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "rider";

  wmClass = "jetbrains-rider";
  product = "Rider";

  # update-script-start: version
  version = "2025.3.1";
  buildNumber = "253.29346.144";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    openssl
    libxcrypt
    lttng-ust_2_12
    musl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxcb-keysyms
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
    expat
    libxml2
    xz
  ];
  extraLdPath = lib.optionals (stdenv.hostPlatform.isLinux) [
    # Avalonia dependencies needed for dotMemory
    libICE
    libSM
    libX11
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/rider/";
    description = ".NET IDE from JetBrains";
    longDescription = ''
      JetBrains Rider is a new .NET IDE based on the IntelliJ platform and ReSharper.
      Rider supports .NET Core, .NET Framework and Mono based projects.
      This lets you develop a wide array of applications including .NET desktop apps, services and libraries, Unity games, ASP.NET and ASP.NET Core web applications.
    '';
    maintainers = with lib.maintainers; [ raphaelr ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}).overrideAttrs
  (attrs: {
    postInstall =
      (attrs.postInstall or "")
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        ${patchSharedLibs}

        for dir in $out/rider/lib/ReSharperHost/linux-*; do
          rm -rf $dir/dotnet
          ln -s ${dotnetCorePackages.sdk_10_0-source}/share/dotnet $dir/dotnet
        done
      '';
  })
