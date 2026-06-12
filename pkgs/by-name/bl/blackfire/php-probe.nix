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

  version = "2026.5.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-FQzmRL1Dk4HBnrfbfOclDWGvqflFXTUMK8b1NLIb880=";
        "8.2" = "sha256-e2+hVsoBXt8gURRvGC4bgAkLpB1GriefokAjFFUuO8c=";
        "8.3" = "sha256-C/NsbJ8XlkBPlZ0lPeNL4SWxfVWSLxvQYDxTVf2PfyA=";
        "8.4" = "sha256-gqEV9thI/oe38/dyrGZxhPtv4+ufzMDXJL0zgt8IbOA=";
        "8.5" = "sha256-kw57CBFOcRpaToXD/V2veXjcQnVaM3uTLC3tgrKyNzc=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-Cccapa4s6Wvo/MOjReCbbJY4H1HNe5uF8Fe4UX8ftFs=";
        "8.2" = "sha256-1k8m4Mram806XIbR4x0Kf6IH7rvhbLbaqPgM9v1SHS4=";
        "8.3" = "sha256-Si0boOO5BRDKARZbAbPPrxRIaUjwViQLepZ5tNvkjGk=";
        "8.4" = "sha256-BOjlJy48fS2SWK28Lcd9/MVhciDEaBJe6mRIhTa9JhI=";
        "8.5" = "sha256-OBySA7eGI+YqvMnsOlr7p6RznqYq7DJptnYjhMfqk2Q=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-Od+c9X4yg4xW9aAI0x1CacUNp7PdJl1KRIi++m4DLY8=";
        "8.2" = "sha256-ZI2n0lXkwUg8BvpjdhqHz1F3Z7dlX+oGv6IsjRVzzWA=";
        "8.3" = "sha256-6NMvylxdwPpbmIN5EDVcBuplP2kEQDyY+fD23k89k48=";
        "8.4" = "sha256-356ECFSrqu5kJX/qP+SNtKl7bsGGD/ROJd9vgEX5wSM=";
        "8.5" = "sha256-z7GMQ9wqIr2/BKi3G2Wf3cZBtU/ZC+uKMcbnmYfmm8w=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-vlb6HCz9KqSL+bSuVixiHVgVVkEAuCaoR7ww0/ZSdR8=";
        "8.2" = "sha256-3XVHonZ7UW3LENuKgywyZ5q3Mo/6XBhnbiuARRGqPAg=";
        "8.3" = "sha256-Dw+L0Bo/6BeFi+w3sm5kekR0mXoMUcsCuEksCdFpVA0=";
        "8.4" = "sha256-i5R+vUn08yNWvPaJGRRHBPAbpxdqDmvPq3l9NPCuqxg=";
        "8.5" = "sha256-vyBbyS8Y1mD+zFO01bMbim8Riq45+ns9YA4k41KQup8=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-0xf09E58+kOGZbfpUeaCNdeeJx/Sv4QazfgcdV3Fqho=";
        "8.2" = "sha256-BU3INTjuVXJ+WB16Q/6I1I5y0k+7sR158vKOiuh6H4w=";
        "8.3" = "sha256-TBTuabrEpQR7ff+ULjZCD99a1xX4KNjTWlMQTJ1l6NU=";
        "8.4" = "sha256-45R0CrE6MZ4RU4HslaF5/jbMOz32fCMnzj8R1F9tu34=";
        "8.5" = "sha256-40+kki7h6DLQemLyoKOSdd8hmQXJE+Yt4rcC4V706vs=";
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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    hasNoMaintainersButDependents = true;
  };
})
