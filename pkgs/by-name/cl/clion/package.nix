{
  # keep-sorted start
  dotnetCorePackages,
  expat,
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  libxcrypt-legacy,
  libxml2,
  lttng-ust_2_12,
  musl,
  openssl,
  python3,
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

  pname = "clion";

  wmClass = "jetbrains-clion";
  product = "CLion";

  src = fetchurl (versionInfo.urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ jetbrains.sharedLibsHook ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      python3
      openssl
      libxcrypt-legacy
      lttng-ust_2_12
      musl
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
      expat
      libxml2
      xz
    ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/clion/";
    description = "C/C++ IDE from JetBrains";
    longDescription = "Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
    maintainers = with lib.maintainers; [
      mic92
      tymscar
    ];
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
    postInstall =
      (attrs.postInstall or "")
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        for dir in $out/clion/plugins/clion-radler/DotFiles/linux-*; do
          rm -rf $dir/dotnet
          ln -s ${dotnetCorePackages.sdk_10_0-source}/share/dotnet $dir/dotnet
        done
      '';
  })
