{
  # keep-sorted start
  dotnetCorePackages,
  expat,
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  libice,
  libsm,
  libx11,
  libxcb-keysyms,
  libxcrypt,
  libxml2,
  lttng-ust_2_12,
  musl,
  openssl,
  stdenv,
  xz,
  # keep-sorted end
}:
let
  inherit (stdenv.hostPlatform) system;
  versionInfo = lib.importJSON ./version.json;
in
(jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;
  inherit (versionInfo) version buildNumber;

  pname = "rider";

  wmClass = "jetbrains-rider";
  product = "Rider";

  src = fetchurl (versionInfo.urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ jetbrains.sharedLibsHook ];

  # TODO: Some of these dependencies should probably also be added on Darwin - however it seems that JetBrains bundles them all? Unclear.
  #       Somebody with a Darwin machine should investigate this.
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      # keep-sorted start
      libxcb-keysyms
      libxcrypt
      lttng-ust_2_12
      musl
      openssl
      # keep-sorted end
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
      # keep-sorted start
      expat
      libxml2
      xz
      # keep-sorted end
    ];
  extraLdPath = lib.optionals (stdenv.hostPlatform.isLinux) [
    # keep-sorted start
    # Avalonia dependencies needed for dotMemory
    libice
    libsm
    libx11
    # keep-sorted end
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
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}).overrideAttrs
  (attrs: {
    # TODO: It is not correct to bundle the .NET in nixpkgs as-is, see https://github.com/NixOS/nixpkgs/issues/489048
    postInstall =
      (attrs.postInstall or "")
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        for dir in $out/rider/lib/ReSharperHost/linux-*; do
          rm -rf $dir/dotnet
          ln -s ${dotnetCorePackages.sdk_10_0-source}/share/dotnet $dir/dotnet
        done
      '';
  })
