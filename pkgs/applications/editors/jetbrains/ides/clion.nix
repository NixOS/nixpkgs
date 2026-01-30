{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  patchSharedLibs,
  dotnetCorePackages,
  python3,
  openssl,
  libxcrypt-legacy,
  lttng-ust_2_12,
  musl,
  expat,
  libxml2,
  xz,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.2.tar.gz";
      hash = "sha256-c6DFfBnMihKr/ZzMVy1ymnAE3c7iS45h3GOc5yZH8Es=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.2-aarch64.tar.gz";
      hash = "sha256-zdXJB07yDuK8snFtGEiaICfOl3rD7zMeX+1ZBiagIaU=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.2.dmg";
      hash = "sha256-G06dmosEsKbV5dvRL9RxXTe+XQ8Hlkhf4nEQF6A8QiA=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.2-aarch64.dmg";
      hash = "sha256-sLj5Qod0XwlA+/t/ZoeFrbaQbsP2S3kz/F5VjLkwFgQ=";
    };
  };
  # update-script-end: urls
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "clion";

  wmClass = "jetbrains-clion";
  product = "CLion";

  # update-script-start: version
  version = "2025.3.2";
  buildNumber = "253.30387.78";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

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

    postFixup = ''
      ${attrs.postFixup or ""}
      ${patchSharedLibs}
    '';
  })
