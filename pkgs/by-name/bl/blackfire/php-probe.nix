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

  version = "1.92.50";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-aCnGHhDRu5T/3Z6f5eznfSkBX2c1YlpnRB5ttqCVPVY=";
        "8.2" = "sha256-p7ZYbMqw0rNXpDSvsoLrSiOROsJ37AERXIdp7l8M3DI=";
        "8.3" = "sha256-dLIPHElK0TMUSrR8bEmRC+HgDnNy2k6Kn5NDrEUtzek=";
        "8.4" = "sha256-3cJGbB36HLFZegvhign5H/OLnfLFyaQxLq/ATgkSZHs=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-vDF583yxPy4wvv8Xc1uzwqBK8zF/8vOvoEKlD7oTtfQ=";
        "8.2" = "sha256-j05WBCYwCgmQYUjRi2mqXpnGZC8iAhjt9NBET2duSFE=";
        "8.3" = "sha256-1evyBQFYxe2lnnXYCu7iod6Nv6xGoiT7whP3FsMcuqA=";
        "8.4" = "sha256-9qW4hfpSnDVGmTjkxm2M7wswYAk111XUixzHAFD50YM=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-ebkOcpbS9RzDz36pUKkiaEyITzr8hf4rnF7Jr+6AF6A=";
        "8.2" = "sha256-wPeMSTQpPWHidP9VOjTu1WG8O5V2t0+B7w+SmYsuNiM=";
        "8.3" = "sha256-8tajH81fhYdZhTTFMAWJHqEdI4lojOMcQ5HoUQWLYI8=";
        "8.4" = "sha256-or72I8eR48mOc8Y6lsCaYRbElsqgGr/iDU/FoDTmYDA=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-0a8ZJf9eoirAkRwpjfRlesH3x2MM8vqOoAJCWRHRkCw=";
        "8.2" = "sha256-UUHs4xV1s4Jmi6W5Cil9CdF88SAZ4ocmEL8Ai2EzlmQ=";
        "8.3" = "sha256-hRiEb2X3Z8DVVYZpT6g5HLHgCuW9lxKVHlulfdEFaBk=";
        "8.4" = "sha256-N/mTNRO2rh0WX94NRxwceFd6Xra+Y45MRgFvf+afkS4=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-4VdD62MmFg9xSI+bJhIZJdAfTSs4A727MrmIcGjlfFo=";
        "8.2" = "sha256-OtO/oliN9XdRawDt3XTfOz7xIWvYCYFrhDN1/TUOQxg=";
        "8.3" = "sha256-19Ziyoj+D5ntsvMMVR1NnCmUWAFZKBwWF4l2CvO95vQ=";
        "8.4" = "sha256-N/zYncKEzCkijJIUA09o0WegOjyleGozReGu4VrqO2Y=";
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
