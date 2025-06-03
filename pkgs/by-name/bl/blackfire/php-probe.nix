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

  version = "1.92.36";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-Fn+6aZi8UuyF0f94t09SwhUwvHqjvN6m2HBq2mbr/CA=";
        "8.2" = "sha256-b8YyT9P+KQonwHqXSn17EDRTdTw9CuvIX0PzjvGlmCo=";
        "8.3" = "sha256-YLQi530JkoQfAx/ZBR9w2dthK6IsDSyqq3U+rGugUPw=";
        "8.4" = "sha256-zpXYElris1fjMlwpTwuRDkCdO3MNHCLp3D24x5X/S88=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-3mNgyfrkgiZBkLE8ppans7R72lOeXFup2nwLoP6Gve0=";
        "8.2" = "sha256-PT7virnfH8Ujkol/fK84TmVTc4jK4xGfaDL1kb9bj/4=";
        "8.3" = "sha256-h4Gf4YR2I+R9dMDiFpAN1WB2o6BNP3C80fX7vKEN6Gs=";
        "8.4" = "sha256-lRunm8coAkwiLvPELWquAsoNQEZv0LvL13Hdg+9dOfA=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-DDco6F8cD/D4J3KM1B111bjcJkRxd++CLR+x0azcR0g=";
        "8.2" = "sha256-AQPQQM5Q5wlhvkXOnVNgPLcQpZ5xda/CYFqvm5J7e0c=";
        "8.3" = "sha256-Yae7UVRrIdShIVZDSza9IrukYHgfX5CrVIpuH4rEAek=";
        "8.4" = "sha256-l0+DN5zEqGJLg8Ig5U4PvZGms1O0eZ/PqjXgSw4bCA4=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-xb28nloEKKfJfddrDShBFuLHPOIyBo74erHWB9H5im4=";
        "8.2" = "sha256-vmjjmGem7SdEkBWIjDfxgLQhmO9B/x1gIP5GSlAPPDs=";
        "8.3" = "sha256-l6XrHQIigav6gMpgg7HEwm+2PeuU76AX3je8UVrcPEQ=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-xY/5UQuLM/UrdDvA1WUF117m+Coj3ElEgV3cbelfKvM=";
        "8.2" = "sha256-bGpijGg++VJNZFHN9K6Gx1R+jBn3o+Qeh/RpmPC8NPE=";
        "8.3" = "sha256-3uiTuEmEsp3sKOOR0WxH72pVPCs5ogR1yi3VQ7+/fw8=";
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
