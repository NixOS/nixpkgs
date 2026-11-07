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

  version = "2026.9.2";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-Rh26CehFWvZbri+wE+NOit6Mc6LB55IVZ0FT63/GBew=";
        "8.2" = "sha256-HoaC8XAGxqPvQPkpsqTjBxd6Z8FnB/cjk5uC9ogNMAs=";
        "8.3" = "sha256-nRwvQYootheK0qEWbEJoC82butcJRFz65zhxey56/Bk=";
        "8.4" = "sha256-rqo9U0S2Cuhy+CiILeXo2DW22y9xb/7QB3l7Et0IbTM=";
        "8.5" = "sha256-hf/pe+Go8qhHxqAodbLyn60t1FJGZtQ965pMFCJ4t0M=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-BgOAsLqMqsyXfEIgx/Buaz4jjU1TN8lxVPTSvQzCn7M=";
        "8.2" = "sha256-D1FiwfYF8tRM1uMEWPauY+SzQNyL9kszVb5pD5vOBwA=";
        "8.3" = "sha256-SZ9KFC+ISp5LgElLeQTOInlgoSqWV9+oRdC6yJ5P3WA=";
        "8.4" = "sha256-x4ZTJs1VLipdEEAhjb+pG4Q25a2czBkEPtucHGdZINw=";
        "8.5" = "sha256-zzSZsGu2POr97O5fwKRCwJqs6+lO1HqfG6o5HKL4zVQ=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-QGe/XJt2N7UFpW0ahKo+hCZO7X80L31hAp0D6oreGt4=";
        "8.2" = "sha256-QyhbXXlhBdoNUYJcPOt4w4sA45ELtY4IERD8GUS3I4c=";
        "8.3" = "sha256-+l9RGCmhQsdtqntfUk22d1zVIcAxuLw4mHpe4WcfGr8=";
        "8.4" = "sha256-hUI/z+PNAj7gl9UCGes/TnhV6zK82LMfhEfi72gsy7c=";
        "8.5" = "sha256-MaqGbXacLeDUPlskuETtzv1cXZTO0/EF0IW49N6eZMY=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-oG7Doie9hoieBM649S1XlagBaYAWAjJu2PrzYSDLKL0=";
        "8.2" = "sha256-MJi0cve8+eItBcC6UkuxYTzclB3OMC+Hhlmd++xD1MU=";
        "8.3" = "sha256-3oJtMuVKGUgpduMp7snSdGE/BH764EA7yz+N70+qFNg=";
        "8.4" = "sha256-0HOCBB9dgU9Vq5/F0iKCzumjwT81qxHElPsLGKgVhr0=";
        "8.5" = "sha256-Hi9bC/CigkA3VWFTqfE7JzBcGGJAhUwnmMndHgbFIW4=";
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
