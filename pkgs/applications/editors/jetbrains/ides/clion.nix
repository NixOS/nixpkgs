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
      url = "https://download.jetbrains.com/cpp/CLion-2026.1.2.tar.gz";
      hash = "sha256-Q3LOhpwpU6vrPWEzA+s2ZnbRxo+EeodBUHUYs3Xikrs=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/cpp/CLion-2026.1.2-aarch64.tar.gz";
      hash = "sha256-YM105ozP78oLDmwKL0t4Z4wGjCDh6xvhf/C1oCD6Qi8=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/cpp/CLion-2026.1.2.dmg";
      hash = "sha256-UEkYDJBjRvvUUB2UFsc37kdp/i+1ctqULSKs62/t9/I=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/cpp/CLion-2026.1.2-aarch64.dmg";
      hash = "sha256-scMwDF+mIfx/66cBrvdxp+gU3+qA2sUWqoGCEhPItjE=";
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
  version = "2026.1.2";
  buildNumber = "261.24374.148";
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
