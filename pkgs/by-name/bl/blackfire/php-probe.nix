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

  version = "2026.11.3";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-U6hZoYLToR1RTYzASPgYfojwXeXCY01GOhbziT85bIY=";
        "8.2" = "sha256-zRpcuSAnuUUJmrHS762x3+0CFwY4E08j3PbMiocEvDE=";
        "8.3" = "sha256-1x5mf6QdUkdT8btOrSlJV0kGPpZvpCt9Rae8I4AYHEw=";
        "8.4" = "sha256-1Cki++FerLaH1AAb17XJadZ6CzwF5ZlllAHlbsoQEX4=";
        "8.5" = "sha256-61yf7NCH8Tk65Xk2hmHoxjTqygkt5PKkaIgSCpzgycU=";
        "8.6" = "sha256-t/CsA2PUnDYX7/5gl4wSuP4RU429QzJZNgWAcaIJ8lA=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-8zdoLtCivSWuI8GZt7h5oknQBXJo2p4H01ISDs7Hlvk=";
        "8.2" = "sha256-kaFRpslob4D1rB27H2YqKgjCWkgMLXuUl1l0LTTm2CA=";
        "8.3" = "sha256-cJvhSr36BIBNov43oYQHP2U7ZhPKC9oMiHfeykBi4J8=";
        "8.4" = "sha256-sUwnrdR1lM9hoXcmAbvKtuVfRRlDDfFwaU9D0ewAysU=";
        "8.5" = "sha256-HcDQyaLfX6bx7G2wN9vyJ0aGcvcqDsCAiUeKB5ozHZo=";
        "8.6" = "sha256-dlYL1XW6Lzt0uyq6aY+iGb+1+TZDG2uPr8nClaBqZv8=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-n3VQ2Dw8kd8scpOS4TVTIP8mJi4PaSu6PnoDL19mLj0=";
        "8.2" = "sha256-bkXqefDDm0hly9iQfGzxSw0I2iig9RZfxv5TMCkfenY=";
        "8.3" = "sha256-jSKaCMgzgqQXR2mxW+53P3oBxx6fZqgPlCNOGg9cc18=";
        "8.4" = "sha256-fgnv5bDBE/mRIkEi3u5ByxDtBzg8a1WOCQZ62CMIFvg=";
        "8.5" = "sha256-/ZW38XIa8up54vNKZTzmknQrXgHJ8HT5EH6dyRW+klo=";
        "8.6" = "sha256-CshofMO7oQ+5v4HYLMJdU5M+FKr3+g2gqLvuL6DzGsI=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-lOr69ish3jdMapMgVx0ChCJytZl11H+lwmkWBSh0SSQ=";
        "8.2" = "sha256-syyaSKjW1LED690pivgOGaagVAmsd5Xp05lieGOKp6k=";
        "8.3" = "sha256-CaIhOPCZDbeWacg4PrBTcfeq66gd9LrwHENZKf4eEbM=";
        "8.4" = "sha256-9RcwN1O0evqSN2DP9Ms33NfG4zXpMGOx/jQUWFbSjt0=";
        "8.5" = "sha256-/hJUjfBpSj+CpJEizWp/MxjdllfisUj54EMCXzeY73Q=";
        "8.6" = "sha256-wA+Rj9J6i4zsDQWJcum/+IYInKNZLBdVY6mbSQkpuVA=";
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
