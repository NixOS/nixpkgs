{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  php,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

assert lib.assertMsg (!php.ztsSupport) "blackfire only supports non zts versions of PHP";

let
  phpMajor = lib.versions.majorMinor php.version;
  inherit (stdenv.hostPlatform) system;

  version = "1.92.39";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-SsemBK7XYPmYakcUs3vLY9yh5jg3uQEksrokMztzilU=";
        "8.2" = "sha256-lZYsPDkWWUbmG+k5nNcp2GxhzaMj9UCQswRiU7K5N40=";
        "8.3" = "sha256-5dHAU3EtwzWrKUE9FjevDFRtdfO+dXX8y4wAD0VdTcM=";
        "8.4" = "sha256-MsUh0OOztJ++vwXuDbQ8Krf1wANQHYhWXSiHAU5pm4M=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-lxmH2lg11dP6ivqFq+lB2S87qlKKM7e0W95mfesNrf4=";
        "8.2" = "sha256-7jTEuXYspgo6zTG0R4pA38cGQVIts0rMHHegJ+FZtUc=";
        "8.3" = "sha256-aRrM6GnXBaiggwoPLq6U8T1YaXmYm6Zhd3Ex8JKMCuA=";
        "8.4" = "sha256-tagBg+7FkuK/zsTMG3GmnqPsApdCP8RnqQozY5Nufzk=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-P6sBM2B/w65P+lInWgn3FxZHX4tS0oo6YELsu8aXmIw=";
        "8.2" = "sha256-qYglYx4icFch5KJuWCTgC19EowZNzHFIsh5qK7t/gDk=";
        "8.3" = "sha256-Ob0rg6A7fJBKApGnugV+BAC5HjFc2UpZmxJ0oYnQVRg=";
        "8.4" = "sha256-+cH7t3ElpNPZUbDEkjkeV8d+74hF3kFzI7xY9ruwy1Y=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-5EW9BkG154HQ6TrMyan5EhXiGlSRFPXMMTUasIwuC/U=";
        "8.2" = "sha256-hRjh9Bf04LVBtS08fWMxrE1iyn6SGBQfNNLuSyQPjes=";
        "8.3" = "sha256-WWsDPQhu1GXMDe6NhlMuVcwi7wGzRLJcJwxItxFCOiI=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-w56HItrNtHA8jj9K5LhGTKFRX5i9UYJpxVwR0eFQe4E=";
        "8.2" = "sha256-vkEAVyZ6Vs3VjWb3oNrlRz5zAzPbgIngeoDAHZLme3Q=";
        "8.3" = "sha256-uzobd13RzYGFrXHyFH0Ud9Qg7AWMPAA5dvHCp7R3HrU=";
      };
    };
  };

  makeSource =
    { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${
        if isLinux then "linux" else "darwin"
      }_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in

assert lib.assertMsg (
  hashes ? ${system}.hash.${phpMajor}
) "blackfire does not support PHP version ${phpMajor} on ${system}.";

stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    inherit system phpMajor;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.src} $out/lib/php/extensions/blackfire.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName =
          { phpMajor, system }: "php${builtins.replaceStrings [ "." ] [ "" ] phpMajor}_${system}";

        createUpdateable =
          sourceParams:
          lib.nameValuePair (createName sourceParams) (
            finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource sourceParams;
            })
          );
      in
      lib.concatMapAttrs (
        system:
        { hash, ... }:

        lib.mapAttrs' (phpMajor: _hash: createUpdateable { inherit phpMajor system; }) hash
      ) hashes;
  };

  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
