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

  version = "1.92.46";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-6hJFujEOJjiXoAXJL1CjUaDilAdtdLrA8CK9kd0hHGQ=";
        "8.2" = "sha256-X5TymvtpHJg7Ss3W0g/Wxrwql3XkYnAmU/YVObpTKng=";
        "8.3" = "sha256-uvFHjEKKZjxu3V0MCB4JHPtDRrx2eulUy7/Vzgpxoow=";
        "8.4" = "sha256-3uN65XeSPUYSTlSiIdtt5sSZYNiZcX52aYHR66y5qyY=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-nPeln8gKeAtlqqlOad4xyIip/X8aD8hCSlXKJWZqiKs=";
        "8.2" = "sha256-Cq9vOEHlO8kA0ksC2HonUJTEwvDwx/Sv94iVtYF6AII=";
        "8.3" = "sha256-WjMU65khtbjZxAPaVHqlHXkmr30jfPyl852DLwUzjHA=";
        "8.4" = "sha256-+EQFAQ7w2JOYUlmhFnirWcY6A6mfEW5ZJ2etuh4j4Kw=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-SpDFIPZUofY5JJmNuOew45a/HemnJdCJ9WjhkRgSAng=";
        "8.2" = "sha256-VPTDV0BjSl67iuOoxb24I1t7dpovOt6ChyU8RWsYGF0=";
        "8.3" = "sha256-at8fs3WQ/X6pVbJ1piWL40Ad/fqbRq8jIUs7kpcsKLM=";
        "8.4" = "sha256-wAHQt6oOmUQfXOhEfffSoT8P34mEzPQhmNWcI/BF8dc=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-jB8w6wNMIo7s3J3EVOpM8Se6wynJRG2advocDKNjRww=";
        "8.2" = "sha256-A5QlkRuLnfy/bSyACXW6IK8LHpWQSh41t0PsGEQAHXI=";
        "8.3" = "sha256-s5uJwSGkl62lfOnw0DhdO5n3d6h93q5LghNHkiSY7Vk=";
        "8.4" = "sha256-j/y8u6lzEqHoRJnJJpEDbBe8WNqC/pqyJtOZ/K+H+FM=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-3Pr2bMsjxzPyWDlYBFLq0uDnLCKfekFAo3XGzHTbAFk=";
        "8.2" = "sha256-PXfXIA3EbHVTFVWk+YpkZWGYSbBjBDbrl5LKcbDRCY0=";
        "8.3" = "sha256-8GsQhnF4LNV1gfBfPjcGNGRWJBcgmPhn1G/SpORST1k=";
        "8.4" = "sha256-NjQhQEfqLGgtgaMLeftm40LXEjs5k3Zuv4ThGbpPCmU=";
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
