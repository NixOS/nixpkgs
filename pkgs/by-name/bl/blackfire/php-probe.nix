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

  version = "1.92.45";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-y7t9llT1hsFPoR4+WCARi6uBAVbzvwMtq1VsLfp0Y/8=";
        "8.2" = "sha256-jnk36whlYfX5PWyEn4ZV/r1mHKssh4EU3k9Vf2kj8L8=";
        "8.3" = "sha256-Ygn64hFgGWiqUj7+A3tTv3A+pbVm+hcDwUUbks44j+g=";
        "8.4" = "sha256-T/JrOT7T+ubTqVxu4cZc1Kt5xYXLVamx9cp97W8ynzU=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-ZTX3yBpbFYPOyNso85ro/guS2nSWHa0NMOIUeO8nVpo=";
        "8.2" = "sha256-3Mm6wQirBQaapL6nz6hUUwxSsFwo8RHBaVziluQHhZ0=";
        "8.3" = "sha256-hE1sKCAANxcyT5H5D046/v70R0cpb+bDaG6+vj+xpCE=";
        "8.4" = "sha256-hMNrxdoF6O5ufbr53HFZVgXSTkvBcEXexbGMFhUylpc=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-FbKTKv6kR0vpzmW5j5iWZYHPc9RiWtLHWycRQu85lIc=";
        "8.2" = "sha256-0thhuN5Lyh1fq7kWk4hJ0rSdzrPJyYvo7NTWumM6Mos=";
        "8.3" = "sha256-FMebTeVDF2kG46mScaz41808YCV8oGcMyxD0GkW08s0=";
        "8.4" = "sha256-f1y2zagiNhf+qkyIamR3MtBTF5ck6hj3r+FrtYJUPwU=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-MQ8WxDISXbr8YUraPduWY0xyuXG+4M8f/x364QdWSPM=";
        "8.2" = "sha256-QVo7yULvj8VMbvy62y7I63EhoWRGqCMLqWQ5pLh01YU=";
        "8.3" = "sha256-J9kg2BxWi+6VWEPqRx6KYf1uhpSvyyLazivoViQtAS0=";
        "8.4" = "sha256-Ma54Z4v/zhwoJCL41jr+FotQezxHbww/iiqlPAD1Z5A=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-L8kk4Nsb3Yk0XvY1rH68/Y6HqFleEMstigh9dV/NR0k=";
        "8.2" = "sha256-eQRMCocfbTLw8KR0TzoEcEgnArAHP1kW2uThDosRYhI=";
        "8.3" = "sha256-q6KbmeGYhxeA9ki9+gWs0pRjkTMWQkgJbf8GzO8AxRM=";
        "8.4" = "sha256-w3yr/Xu+1s9MsO/BFeeF/e+DlM8LgL66X8bj9zK/auY=";
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
