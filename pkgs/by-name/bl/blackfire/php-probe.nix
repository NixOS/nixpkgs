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

  version = "1.92.37";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-NuWxVeVueKz64jDIE1KPzLEco+MoUyuc/9/hsTaRrAI=";
        "8.2" = "sha256-NJlrEwSY55INO7q5GAvPojnLdkAYJ4eCIjxFH55Pdmg=";
        "8.3" = "sha256-KGpNPp2bOAmY/GUPnUxTJ4z6X8AdvZAG6YC3pLTjbGI=";
        "8.4" = "sha256-3HrbezGcdVMtdPrfRpLEhY/1AXlGUIMraeie7LEmiC8=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-Z9D6yoDSTdvzAQw+LhCk37J+LPMLEthUzbB1YQdr7AY=";
        "8.2" = "sha256-ES2Y2RewFSP0R5wuYF2sm7NAVlCRvRPSpfPt7X2uYqs=";
        "8.3" = "sha256-jqcS97JcHU/LzdU08MwNXDepH7OzIa4Fo7s3hg+x6hA=";
        "8.4" = "sha256-xel7bbb4S16YddLuw0sDINbKQ0zoJeeRSI4g+tpqYz0=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-l3mz8n1PjBUTcLN4Kyjg573Ip20dFV85yNT2krYq6Z0=";
        "8.2" = "sha256-EyxrVMitvupQzAwhFDwMO56PUhyLb35aqWgJeH+211E=";
        "8.3" = "sha256-T6UkTtQl1Ce95tA4/J9mSk/pBWAZJJz0pHb3xMIGYvc=";
        "8.4" = "sha256-udvqUMbbVcFOocu1F0rSgi0+bg5VPq2Qw2LrRqNRQHw=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-PoXihk7e+xT6fat48dnD/3lZqQKpgBHs4Eao08J4dMs=";
        "8.2" = "sha256-lLham3VjXvszjOU8NvxZsjz5vfEK58QG1tE4X06luzQ=";
        "8.3" = "sha256-rAsJ71P+yM939JqhhwDbxfL0EwB4q7SNqvSdN0n6ES0=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-6RoANqMjuyaLcMzg5R0unhTwOSbsQhEXCkjQ2kjnnCg=";
        "8.2" = "sha256-PjvLjRsnhHgXOEj7J7ekWM0fFuaOuiYJhXbINClaFtU=";
        "8.3" = "sha256-NoY788iBgeVMrQp3tm6vbAnwBZB7yMjCVmH7jr32HWU=";
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
