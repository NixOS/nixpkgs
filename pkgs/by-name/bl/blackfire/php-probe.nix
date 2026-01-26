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

  version = "1.92.59";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-ZmHjL8+15+d4pwa83PgBft3fqx3lP6Rbfp5SM7AEEYY=";
        "8.2" = "sha256-TbmsCvwthnhAw5YNHKDI4TW67JIbzlAMnj6siQCQ3Ho=";
        "8.3" = "sha256-TtswhS9r+NYsbiHLFsBAD2Zx3pvwVC3UlnRlcEb756Q=";
        "8.4" = "sha256-0dSfHQ3qY24aqjqqdFbhZMKZbkC+UwWG+f8SNYspWdU=";
        "8.5" = "sha256-E6+vcJ8pn2x7V3anixhVrdB1vqfmaJ9lAliolgpkGk0=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-tS+V/TECOMkFQBksiVHs5KMdbCkL/zyHuM7fI4aHJEo=";
        "8.2" = "sha256-lLfPp0I5bfKAciqNgW4bqClZWfM+faRSfiWncSr4Vqg=";
        "8.3" = "sha256-Z1j6UcwxMOokHHSJKkBr3eZ7BXyjeji6FnJmwn0kAyo=";
        "8.4" = "sha256-+/rTUtVI+lKhfpvCT9ygCyxNU7xXVW+1OokRMFz31Cs=";
        "8.5" = "sha256-eudbt0RlFDy5GCCw511aFf4LWyoKx1O9OPAYNw28RiE=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-juDla6bzJTUFMpXlUOIKTp//rnebp0iDCTDL0wnpIMU=";
        "8.2" = "sha256-QcTpikieBPDhnB7X1TNy/YK7SZMscwxzrAQvF8olulc=";
        "8.3" = "sha256-Y51PEayEvhCafKNOzXgx1whxPpbIUIcUurj+MB/ecP8=";
        "8.4" = "sha256-VBo27DCTFNcbsZ6kZj49hoa5ZLFTYuPKFwA7xDbaYxc=";
        "8.5" = "sha256-NI11KNa/+bAXbhW8GuRUzZqbC4dM6UVTOCG9ClQvbrM=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-LsaYDHj90wmp0qerBJjT0eg/M5rs/6ZFqu6uNmj4Dmk=";
        "8.2" = "sha256-A9KRabsrffZLKZ4JKSRqWfmdEKh21MbvREPUkWrxdVQ=";
        "8.3" = "sha256-BtZJd/LceopZOIPH5m7ZckYkrD+mX5yI61lXHwktftc=";
        "8.4" = "sha256-WHSlmiMQnNAXDYoNqHhaziMsDQlI6b7iwWJwQcMwVJE=";
        "8.5" = "sha256-fD/nunmPBPefupmpHt8WIZfHeqrtBBLGvKn5fzTAYek=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-aVxMAcXIm89LMeIUzducZpkhK+hxa82BR2s5EW7L4Ng=";
        "8.2" = "sha256-EmHdXFxhFqlzi0mktLOz54cQXcvIcfDmGmyVxJRmVLU=";
        "8.3" = "sha256-7Q3xuM3xwlcbnlj1ac6wOC+MnlEZqQgUZhEtS/I9fNM=";
        "8.4" = "sha256-DpiNuofmNf0cpmCsZNbXBqr70r11q9JjKJJjiwP1sc4=";
        "8.5" = "sha256-ISZUPGamin+sYuOfRT9uvXB2lZDGR8kzRFLjmgrVlHk=";
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
    maintainers = [ ];
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
