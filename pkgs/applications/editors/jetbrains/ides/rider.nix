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
  libice,
  libsm,
  libx11,
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
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2026.2.0.1.tar.gz";
      hash = "sha256-fpc9aJufO2Qiw7dyr1uOsMHsvBruFuX4D0KY1erpmwo=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2026.2.0.1-aarch64.tar.gz";
      hash = "sha256-MuK1dvi3fnPdSyETPeEkW4k7hNFPkHYtaKjp/IZzdIU=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-2026.2.0.1-aarch64.dmg";
      hash = "sha256-q0UXuh2RuH0sC1kqbjv0QcxmLtml9v3qeLRVcjCCVuw=";
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
  version = "2026.2.0.1";
  buildNumber = "262.8665.385";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # TODO: Some of these dependencies should probably also be added on Darwin - however it seems that JetBrains bundles them all? Unclear.
  #       Somebody with a Darwin machine should investigate this.
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
      libxcrypt
      lttng-ust_2_12
      musl
      libxcb-keysyms
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
      expat
      libxml2
      xz
    ];
  extraLdPath = lib.optionals (stdenv.hostPlatform.isLinux) [
    # Avalonia dependencies needed for dotMemory
    libice
    libsm
    libx11
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
