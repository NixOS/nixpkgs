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

  version = "2026.10.2";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-dCbVzCqAtguynbutdc/RMqmATaO6Htv/LQM+h8a8rWQ=";
        "8.2" = "sha256-B8YPKmrNf1PYgRCT9I5qA2hT9DXQmxra1rtM/DOMkdY=";
        "8.3" = "sha256-KMN2yzueRmgPPWx93PONotnEB3r65NDbuzlXg1jwn9E=";
        "8.4" = "sha256-qKcMsfQtPpNjpG+DUA3eAjcqK4i5OFNzuoQ5w5VZWQw=";
        "8.5" = "sha256-tEu8HxV91bDbUpNUKuWLS3viogH5T93TH/i1Z3Ex658=";
        "8.6" = "sha256-usnJ6SKgyQYY93hz7u2TE/7JlCwp183ORwIyUH4HMb4=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-CW8+JNJQanMunorfKuHKl3jVJaR/SEJDwYS16GEBqsU=";
        "8.2" = "sha256-gbBs/YNA38oKxY7tplG1754W4VY1PLqEgSVaHPkiueY=";
        "8.3" = "sha256-2Ut5zWjSkwJQhR5OmnpFbGwqK3biPjZGuTYZV8tLq3c=";
        "8.4" = "sha256-k42DY8UdVL5XGXBDT3OhbtXMk1L3JK8g1aTICGAKk14=";
        "8.5" = "sha256-Y6l/YI0Hh0wtASj2NVKBGYbGYpTUMc8/mWkmQ7s/avg=";
        "8.6" = "sha256-+qgUMWXqvzF2mAg48sPt8hsUvQYKtlPwKqazoPwUR3o=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-dw01nNa012lOb+vl+CQcBrb+HuxGpHFzRx7n/xzEKGI=";
        "8.2" = "sha256-A9Wh5coveqRfZkI/5mZ8UFoWkdCbrKKOo5sBGdzywXA=";
        "8.3" = "sha256-Yh3+eWwZL+UeNwgyJ/ubxyERw5fh7sRFRweetRRLrg0=";
        "8.4" = "sha256-0Q9/+Qxi7tU75ME1QnYdR3ZlHg//BehOwCJzscSEGM4=";
        "8.5" = "sha256-IH+CMvxh5thiUh0aGeVI+hKQgCb19EzEOQXSvFc9rVY=";
        "8.6" = "sha256-l/7hIT8QljaXN/nMrKIqAs70qhR+rwEFk9vFI728xvw=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-CHeO7rsGK1gb7oUWRc2CAuvV2j+fgQL/+gHteYGINSw=";
        "8.2" = "sha256-lHi6aew0Sz0EFVtW7NtsXraOPc5CHZLHuF0Hpo6PNyY=";
        "8.3" = "sha256-3s4NeEgYOCZuFVzJ+ZuAR1+tpVdd37++QDLCQVTEQxM=";
        "8.4" = "sha256-L2eYCxMpCATYg6qoR3HOxpKX9pTa78m4Ga9OGOJy5i8=";
        "8.5" = "sha256-i/uvnAd6TUljfFJw5JaMoz8Z1UplCJpDmlZsR9XKxPU=";
        "8.6" = "sha256-/YayFtWgpZqTonugjB9weueAMU+zsy7EmC/so1pb8Jo=";
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
      hash =
        hashes.${system}.hash.${phpMajor}
          or (throw "php-blackfire: unsupported PHP version ${phpMajor} on ${system}");
    };
in

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
    platforms = lib.attrNames (lib.filterAttrs (_: v: v.hash ? ${phpMajor}) hashes);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
