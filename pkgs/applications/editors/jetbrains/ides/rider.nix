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
  xorg,
  expat,
  libxml2,
  xz,
}:
let
  system = stdenv.hostPlatform.system;
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1.tar.gz";
      sha256 = "ba840f7c48da7f118cf57aa8c22df30120d16f175fbce3bec6a65590ed87f2e8";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1-aarch64.tar.gz";
      sha256 = "19080fcdc48fa0f743ed60927b71975a3c478b805296161cfd8a0aa2c04c8f52";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1.dmg";
      sha256 = "addd816dbdf130e2ef5e7dc184d7a8087f8bfbf6eba4e32ead2452069a49607d";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2025.3.1-aarch64.dmg";
      sha256 = "d7080323412900f5d37270233e5a4c773011c6853d6031ce1f5e635c77511426";
    };
  };
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "rider";

  wmClass = "jetbrains-rider";
  product = "Rider";

  version = "2025.3.1";
  buildNumber = "253.29346.144";

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    openssl
    libxcrypt
    lttng-ust_2_12
    musl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.xcbutilkeysyms
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

  meta = {
    homepage = "https://www.jetbrains.com/rider/";
    description = ".NET IDE from JetBrains";
    longDescription = "JetBrains Rider is a new .NET IDE based on the IntelliJ platform and ReSharper. Rider supports .NET Core, .NET Framework and Mono based projects. This lets you develop a wide array of applications including .NET desktop apps, services and libraries, Unity games, ASP.NET and ASP.NET Core web applications.";
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
