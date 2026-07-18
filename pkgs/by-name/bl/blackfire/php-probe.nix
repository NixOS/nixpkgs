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

  version = "2026.7.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-fs1zJkObPMoG6hta2fCOO6UI79nkqoKGNN7S92NSf0c=";
        "8.2" = "sha256-UITSNAWSQfo2CNldoXOEETqk1sDEhExp0bLDHR8GNQo=";
        "8.3" = "sha256-MPg6lGEt1t5y+fiXDATHeutgaSH0o0boTjTLGqliyTQ=";
        "8.4" = "sha256-yIYdl+IZzk1sJTg5Z5KU8o1MNFwUK46DNUPkdGWPmpM=";
        "8.5" = "sha256-Zrr1Rk4dcRTxUNowmWAWxxwhBaCXCxXMOGYrJfp6HHA=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-akPwQdmUplIG0o7uNXuPBrv1QTG4ulXMD+E9FFf8cdc=";
        "8.2" = "sha256-o2T8WLXk5N21Z2kLZnHiyoy/A3I9cqwY/ezlEpD3LOo=";
        "8.3" = "sha256-FqWzbE8o9IsmTfeS46ZLawdq8I+ttRU2bUIeruzDNO8=";
        "8.4" = "sha256-x8zmKWdffLPL1FIpEtnK1pio6Pdj2gacwTjhm5FUASQ=";
        "8.5" = "sha256-l3Sb3ONIURDikQhfhxbAABwVFZtSQf+R8z3z82Dwz7Q=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-rBKmlBuI7Wj4HbcaBEgB21OFmPgYKiLapswcuxGVWp4=";
        "8.2" = "sha256-H3B3e4zP+DSL8XkpaMZ6yhp18TJJrE38SQlc9N7QaKo=";
        "8.3" = "sha256-Cwm69608MEkmqgJMJCTEY4+1DHCMkawjDYb1eZD2U4c=";
        "8.4" = "sha256-M8y5VoaIHTsJEcYA61oK7Ks6oFCqlCzvo/uQbJM12pU=";
        "8.5" = "sha256-rNsy+IPEnxqH9pP99sM9mMX7K1ZzhRJQx9BuJkEvUD0=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-Ou54kb3vhRK9ZP35ixc3cuXC0s9B6yOMoxS8QWn8GH4=";
        "8.2" = "sha256-Xx9h61zzDI4dA7G6nqJA7lgd1TzmhQmvuFVhVRVFHz8=";
        "8.3" = "sha256-/EM1fAYaEHtBnN4ElnCaA6RvcYMjhx5nhsmA/Lxx3jI=";
        "8.4" = "sha256-W5A+WAJ9MNX4Zkmhu0v5k1KQvVtSJn60JpRvVuFD98Q=";
        "8.5" = "sha256-GpvF7cgcTXLguwQCj0vOwtn7EbUQYqolzt7JPr8RtCM=";
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
