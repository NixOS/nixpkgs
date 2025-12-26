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

  version = "1.92.57";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-u/usYeZO/PrK0+JSnx0ISgqamfr+WbafzZQa4MF9gmo=";
        "8.2" = "sha256-UYRTsi4qC9V3TtBH84Lz74Tub9juLe10p1PwqfZ1580=";
        "8.3" = "sha256-a31XDT+XDnY2RPCECYbmlxW8kTW/K62hqipHbebGt0k=";
        "8.4" = "sha256-NjqHomcEGkozMryEdsTGK9skCUIl22Vvb5CR7Sk8w4s=";
        "8.5" = "sha256-wUBQyj9RYEwkdHH4Ov521JLOJ1ENiQppkAqjvBY6zYw=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-4QaL5Cn2i5GfZ+PDT6rHnvpz+lDzjabFWihY9dme1cI=";
        "8.2" = "sha256-XEWB5Y5r51enmReQJz097KXtrHoxN7Eutfs0p7l4GcM=";
        "8.3" = "sha256-VTkpezRO1c7AyWDuhEYA8zVbsy6t90LYz2uAFQQpYPk=";
        "8.4" = "sha256-vI3Db6NCbtgpJvXw9n5U+ZixtPbeG2+5GXVEX05jMBk=";
        "8.5" = "sha256-1S6oTVCeHt/DdQpYDQ/TOeUr8+OW8UQxYHuraeAfOBo=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-bZr5PWzo4iSCpiNpljYrs7J+nq/gh80n51VvvsRxGO8=";
        "8.2" = "sha256-nPfCaIY7eFe8Eut6GP1JeFq0u7ypastz8Qwc07NBdMI=";
        "8.3" = "sha256-33WmcKN+/EIm9d021aGTXz6wGz5rTsnGIsouc3RD2iM=";
        "8.4" = "sha256-p9cG24X7gRHmLdKL2g7AG7a1xZPf78r31a5v79M6pWw=";
        "8.5" = "sha256-7CwilhP7/AnWmsg31yJkl38VW9ZyzBGakkzd4F7YGgI=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-PRWX9omV38snEDp18nXdb7A5BEcKs8KF9GQAkMpPXS8=";
        "8.2" = "sha256-csL+3iboY0uIIDtlBtNNBtdTJlE2PoXf3zxYj/w6k3Q=";
        "8.3" = "sha256-CTzCjCOVgJiCjZ1vcW9k6Y9SDKbjf443mf+FKw7vQ6o=";
        "8.4" = "sha256-Ilyc0EAWPcnf2bEhzSq8vSZGNeY22R+llaODt7Mh3EE=";
        "8.5" = "sha256-x4Qx+dMkpQZ81YbR+Nwuke0/DomUbwqBCDhihkqzBzM=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-Us8awQdx6j5c7HgKIJ523cPTQ2eTiVpfabmrtdG7vaM=";
        "8.2" = "sha256-bnmsXH5WJBvJ1jut0Eo2tBk5MlKsI7S0/2/TmmHeqv4=";
        "8.3" = "sha256-EqDj1WozcDkC9EyzXudWIunGgs4xcpgl+4hu5cddRIA=";
        "8.4" = "sha256-B8GZzMHPnXQZSRYQnWbakrXREu05LEZKi6y9luKEBmU=";
        "8.5" = "sha256-OQRBXA5l3x0Ol5HpLcp6EIWjnOPDqDGmLhe5hCS1PA4=";
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
