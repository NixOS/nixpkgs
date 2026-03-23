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

  version = "1.92.51";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-HxVqkPupo3LrKfbQGOqoxpGJjFN17Jlkdya4BjBsBVw=";
        "8.2" = "sha256-ssbMa4Wa27nwhJZ16FT+qrB4LH/HztOtCx+MI+i16Pg=";
        "8.3" = "sha256-p9SXxHQGmsjtSeRFt9vYS5XK6nouT7qbqmlWbEpb2Hk=";
        "8.4" = "sha256-ArI/SNjPIbjwEBMHvKCdSOkth8qqBWT6W0RnoWyWA+o=";
        "8.5" = "sha256-5e4f9iEn5QPZY6Z+05O7QxTwaW+cjmP6nB5fkpValoM=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-mTw8v5DaP7D5qb3XwRZvx8XH4bTiuu2xzzo82KsrrZU=";
        "8.2" = "sha256-Vtb0DVfPBC0JtK1XOPQ8KmA0Jq0pBBA3jkDaCV7icGg=";
        "8.3" = "sha256-vnL8gfA6ejMcpnfKXalSOvl7vixwQLJBC3DTO4Dafow=";
        "8.4" = "sha256-x9/BcZPJib0hal6M2vUVk1cLmN1gc3k6hypViTqForo=";
        "8.5" = "sha256-aVmQ8vHS/oQeb44RyV5hggOt+VXLqP7wKDxgfpbopQQ=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-S41qr5wU2dsK0IBsR/mTALguPQU+SKYVTLP7DwGQo40=";
        "8.2" = "sha256-eQkvDRxwQNXlkZ9XzcSRfkKjp/CTZGaFwolXq6TZWaE=";
        "8.3" = "sha256-GBjjx0cSJjYCOdDiArUPA4iqOcgpk3y9o0wi6b6UJgM=";
        "8.4" = "sha256-s4zcHogsOy1GjTAGJuO6i7S6dp/lmRVzbjJk3/t8Zn4=";
        "8.5" = "sha256-/lFwv6p9izXj7X+pqZe9clcp+wSYtzIPnwqeE/HFqNk=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-+ko465G24UELdMmEg4ZqOA9p0/0DSs3p+On6Gg2IVMM=";
        "8.2" = "sha256-TERILY6E1vnl+L6t+oel+1H3HTHWTTeEb1rVXtriJ8w=";
        "8.3" = "sha256-R5Ue3erVCe1gOPk1SuDRXGA05WPm1IisHCnbXfmjFcw=";
        "8.4" = "sha256-qqbmZa4qd7Ck87GylHeHP9m3K47DAEiTxlKdtXEnzVo=";
        "8.5" = "sha256-3d9glqfXCMXwtLZm8fuj9DVzCIczynX7MRxnbMC7/NE=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-XvV6x8LKjR4j081PIdKpYCVl+ayXOmPsXf+gsMeFOro=";
        "8.2" = "sha256-qxFWj1HpWokwzsFTiRhi4vw67H8yLwu1xbhja+fAxqY=";
        "8.3" = "sha256-ffrwc48MZzX0MJHbaDmWQpday1LicOxhR2+fwylItD0=";
        "8.4" = "sha256-P8j8gc8lZRbuVd1UmSpYmle88h50vhJfNxTZp3v9/Sg=";
        "8.5" = "sha256-zy24hLCTajY+BVdkJCiXoy8abhQ82Ntw7Wuqn6zJKOQ=";
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
