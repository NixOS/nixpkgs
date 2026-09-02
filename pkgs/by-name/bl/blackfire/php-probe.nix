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

  version = "2026.8.6";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-lZyZjyLFcjWDCyA8qoHvWA5UTMA23nwJ60Pi0qnF6FU=";
        "8.2" = "sha256-CyukBCV9EDiFYWOhyren7mLDS1m1K43Cqr+gbKONPZU=";
        "8.3" = "sha256-6lXP8f302H0isG4a4G25G7F9SeN1/iSN9PXBYoLusOM=";
        "8.4" = "sha256-LZN56S7uvMfa/HqJZihbJlOH0tRhSXF1C6vI/dHlfJI=";
        "8.5" = "sha256-xtf4tv37DElCPJqSZn+21+wpkYF1jZ49Wgu9pJhPbbs=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-ssEimBtjlRPI3bNMFT+iizetVkv5SVUn9zadHZ9wPr4=";
        "8.2" = "sha256-DVz4gm28JhIT0mSiwWYFtRwZ6NJJsrSmS2yYyHLhx6U=";
        "8.3" = "sha256-2Kn1J0ckLyls3arA7cGQcJEAYP7gob6jbNwAZrCrZ9g=";
        "8.4" = "sha256-k++71n+gUGqTGS1IKYOFoNoTgQpzakFDoU1IFzqqN98=";
        "8.5" = "sha256-V3U7GbEcLXw+5jGZCh3QWZa8IHcy3db2/emZhw3IHdM=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-0SeUcMZGCUrKWD/FI9p0nkOaEq2Q8PWb42esHXFjsNs=";
        "8.2" = "sha256-wTuS7IaXRg6B3qxH2QkacuHAq5bbPcqPbVDxgwxy9mA=";
        "8.3" = "sha256-/65Yjji+2Hi/OdhZIin3ttidHbZcprYA33e8SIoK6yM=";
        "8.4" = "sha256-3n359rNQatVNmKmFIwfQRR9+DMBBhI4wcMpHyJOVWtY=";
        "8.5" = "sha256-GDv9gZ2KD8281P0xrzDkq1uI4D5Y4uTMCbGNy2tIcfg=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-5gdDsxSWTpxGjelGMY7nyvoAGGC0YftF9qHKdw+XbUs=";
        "8.2" = "sha256-jF4xbQ7RAcyb0obbeiJxJXAwLaW+cO8Yf22ZGU7cEu4=";
        "8.3" = "sha256-aNtRucr7kBBCAAOcazFq1ZUHDtW8FJpEwqHeYnR0zO4=";
        "8.4" = "sha256-HAlT3o6QRVDG07MTDGXxp7cmysoHFN4AdZGhUiaol58=";
        "8.5" = "sha256-NRKTuUVM2sMKARfMFlccY0by77kt3goi+B69snmQpC4=";
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
    maintainers = with lib.maintainers; [ spk ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
