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
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.1.tar.gz";
      sha256 = "44ae3da5358ba010a62d55ab412b72f364c5dcd2c2dcd2004ae34b7463807bbd";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.1-aarch64.tar.gz";
      sha256 = "b96c38c3d2f7ff7b988d75c970fd0e90363e09b8273106defc9ae3defa868ed7";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.1.dmg";
      sha256 = "9a8174c9229f9c86f86da1a8e2bdab52ffb369ea0781b57eb245703ebc8307e2";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/cpp/CLion-2025.3.1-aarch64.dmg";
      sha256 = "11cae8aeb43d1870d96980f1d927ff545fabed989f3bf4e7327911b441e149f1";
    };
  };
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "clion";

  wmClass = "jetbrains-clion";
  product = "CLion";

  version = "2025.3.1";
  buildNumber = "253.29346.141";

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
