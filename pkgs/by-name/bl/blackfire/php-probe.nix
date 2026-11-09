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

  version = "2026.10.4";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-qrwrvPX2xq2cMmS0si00DiCBlXiec8QPYot+N1HwsAc=";
        "8.2" = "sha256-V+pqyuGpLmRwkYKxnSZJ3IG3YuPhe0YN3jmpNmR54dw=";
        "8.3" = "sha256-+pbjjO3DSY4YW+thIYLupiQ+QEVMx7umR3fXLmR9c2I=";
        "8.4" = "sha256-14uJeYFVmPekXQEWPgurWYWH1JOy0XSDugfwF1t+eEw=";
        "8.5" = "sha256-XXe2GECe0VYZWztZn6uvBLpNxSnW/c4Zz+zqEi5Dkdg=";
        "8.6" = "sha256-bj4RPgC47FV9y5n7EeYUtPD2QOFDN6R7mcxOi4x4ZKU=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-zI3RAnKCUJO1RTCJiICS7MHUnpQvKGwOT17WwtlYJ5s=";
        "8.2" = "sha256-fDk5VlIIC/ZAikZcNYsdEIiPWnmNEDNFJ+9E0OBuzHc=";
        "8.3" = "sha256-0YcNeiasxp388k6LG5g0RM912usFoQSjGkMpHaH37x4=";
        "8.4" = "sha256-XCAl9T9EIjlkAFjVqIbrVYKOKOpJZbgS15eAX09PeBw=";
        "8.5" = "sha256-SeBSjIaNHADVh64Qy0LKH3SLDo/5CUsIXOArAPo2AyE=";
        "8.6" = "sha256-DcKQevIjaXuCD72qBgSd/cQNr+iczQU1/repg9ZFY1Y=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-xfGUvVK8xMzFyKXLLswYArdYzFVKitDp9iNo67gDwGc=";
        "8.2" = "sha256-9tG2VOTOn+pZlW0MNgBObuykw7uOnWz08mAcQiqprWM=";
        "8.3" = "sha256-QFdKoY2RH7bQegjMeHVCDSmdJkPv47WQvUut7BJFalI=";
        "8.4" = "sha256-G2SOpOYFdCNUxmDmPnMVVdPXtegqdGuc6XSiTrHH/DA=";
        "8.5" = "sha256-W2WyIq1ELqmswb34TAk1vizKwVnuGxlTSyHwyQBvgYE=";
        "8.6" = "sha256-4fY7HKMh0UP0rwnbXacvcJ7JaS5VBW+2j2fTPoEWGoY=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-k3pAgvNil3MXX+xEcoMh0JwiWtOMBBu6GP9ReD380bs=";
        "8.2" = "sha256-lkiKFhLk8O/Zbxje4jiqcqmDllyt5Unq0/mHk/SakA8=";
        "8.3" = "sha256-hm9z9cHufTqiPaAf6n2e48MbYlu//jxYFvJmc1MaKsc=";
        "8.4" = "sha256-PHIzFcBkNB0Ro7vj2jUTY39gOEZbcuvtzzff8sJSgL4=";
        "8.5" = "sha256-fICz5UhbzsX60ygg8ZcqJV3HrgXlZMoTrp/V2I47rmc=";
        "8.6" = "sha256-qvz0UarQeoiQcrjsaRHu5A5YRaLQw9WUiYFn9nQy1Fw=";
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
