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

  version = "1.92.40";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-5yfhpseazq9XADYR4/Wo3xg6jGNbSdFrTn+cP+pCbN4=";
        "8.2" = "sha256-ipUXh7pV9qiol6j9PpOyAyxriHDpBHDWin/dIxl4AqA=";
        "8.3" = "sha256-6JcS+aTYhT14D2/wwxJad4MnsilgSjsckSzsx+lVvOM=";
        "8.4" = "sha256-XYcRjHRLhF3f8INEnyGNnhrZlwQGt0wIdGtY3TTnA7s=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-+ApXqJCew4/LKNc+nzDDat+jyqCs8P/kX7Sxt7fAnIE=";
        "8.2" = "sha256-IxarxqbjA3Rei7eR/AUSOHSCoLAsHPwebIXQJYW05Ig=";
        "8.3" = "sha256-HZAOO+VnK3qax/++jAKllHSbCVAgUeEmlSr/HVsXPQY=";
        "8.4" = "sha256-uRG07BkUmZFMvMzVsuF0qRF/wv74QqP2YtGV1Emgcsg=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-PkXmLsLwNF132SM+aOA1mfc+6EoaBlwpgoKTKXE0JFI=";
        "8.2" = "sha256-edsH+Xb0lrw9Dg1aHHtjRGMjGS7+ZDxk/IJFZt5A5ho=";
        "8.3" = "sha256-uP7bY8Pw/1GNdTd897eqsiVfQKr5HLVJ1BVHIloVdRA=";
        "8.4" = "sha256-5MqridoL7fcMXnmC+XJoj3opkmrO1dVQWbZE1ot5y+E=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-G2Zq6n1Ndx5MN3hbDlPDpT+wpNcYBm+mMnbnVNfAHvw=";
        "8.2" = "sha256-9i65PvfjmyFWmgjQPyYRRLV/SOX88tFub2+XmnRlgVA=";
        "8.3" = "sha256-Lf1p55Ae9pddT3Z82h7p/9jC7zN5Md3hOzXXLu/kDjM=";
        "8.4" = "sha256-A3k/IEyDoLmGcJzl60nclB8f+lUmvWXKF851ZMpgwfM=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-3uCvCbkpaawMnW6IXS9VPp8GU4SOwqh/9oxcP1W3h2E=";
        "8.2" = "sha256-PCnUHwtNex9juVL5evY37qyuDRguZs4ByOfOnY7HQs0=";
        "8.3" = "sha256-/3XZPG8+O71sbrVPDg0Thn+pTPGNYBTkJ3s/txI0Q3k=";
        "8.4" = "sha256-XY2rS2p1WAVp1Rd1V8JUnCiTQe2WouLwlmtZTnRqs04=";
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
