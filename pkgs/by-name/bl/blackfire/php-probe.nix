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

  version = "2026.9.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-0AAgiBdiIQOxSSttD2ERzSTqPM1rLwlQFHZ6ARRSgmI=";
        "8.2" = "sha256-usSNoM1XeVWKuHLlSMvONAucVa1ZEAb3+I66oOnzGB0=";
        "8.3" = "sha256-65GoEhgFsQbQleSVuRnHPSZAiCfEUmyVWWhnybnrgaA=";
        "8.4" = "sha256-0if1fQa7b41TjC3d1ck65cJP7lKdoL670V9t+PLL+qk=";
        "8.5" = "sha256-3k5jQ+vbxLGp78MRzjiw7uP+tCcEs5gAYM2MEoiYdtk=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-fmmbY4ecnE05XNxGKq11HcYhs9z7SggLx9iXICHE6DQ=";
        "8.2" = "sha256-9WP+FpULl0PQJ+0qxxZfm5xJS/A6N137yGk9gv4cYvI=";
        "8.3" = "sha256-Io2gGAhXLAVdHoaKwKvJWA1N71IJAKeJkudLs8DZUl8=";
        "8.4" = "sha256-JoGiB8ew3D/qSi7Pg/q67mXLsUy4UDVsazgxgb5BJTM=";
        "8.5" = "sha256-bSfbhFHV8Zs4cpOfDnKItNlF9++0opUtosTpnosacdU=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-7/2Q9Kx3ZEpI0Inj88CfTDzr0sjVpws3DH8KTP26PR0=";
        "8.2" = "sha256-suFGyE94wY4xHfPk77OXzkqU+Ulb+f42drDZY/M9ZNs=";
        "8.3" = "sha256-z5IfXX7DElerdRTnq3R95t8IvG0Hl9EKXBw1QbRlDkY=";
        "8.4" = "sha256-ceTjQ6gtiWJEte5WuVuyc+eTEb3khobYoCWNGP+Vkeo=";
        "8.5" = "sha256-1jX564B/tLBgb7jN6MB5DfpRgYy0xxmtAaAv768FQqo=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-JQZKX8qChvBS3S8cqtxmooZMsFlFqfffnQbNldYNR+M=";
        "8.2" = "sha256-nGQdweskEw9tiK51IGcu7cGKJJwtmNBL9fZLMUCuiB8=";
        "8.3" = "sha256-sHQOg6QC+Mm5KwQVwKmeOVR3fUkN2NH9utHs667Oipw=";
        "8.4" = "sha256-Btrz+U9ejW/Jl1cWBRt5XGV1IzjxK+FJaQwXIgYR/NI=";
        "8.5" = "sha256-zSQeBioU/3c7HrqEz+9z8vam3EHkR0KbC80/mIuTAFE=";
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
