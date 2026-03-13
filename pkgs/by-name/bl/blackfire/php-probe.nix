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

  version = "1.92.60";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-D2e+DV/5ShNzR8M7xfNEMHICatPjR1f/cNsqqUxChNM=";
        "8.2" = "sha256-AiWeXO80wWRCL1BnihChypIvB/BysvZn0hlCP8Htru8=";
        "8.3" = "sha256-elzf1Izzegp/BWm3yQEqE55zkAAM/yzGf4/t7Qcq+Ho=";
        "8.4" = "sha256-iZLl2sfx/IA35xD2ijcHXKhX6GffkNFTRGOEvoRnoeE=";
        "8.5" = "sha256-nskhe/s4D4/VDuyrbK3h0MpP1lc2zFVhDNeCNIExEN4=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-F8bQOTzISxWhyao0oZ7NM014qsMeHIE9OFsCUvCNGp4=";
        "8.2" = "sha256-iTiQUhSjKsWWJ2QI9C+Vw83FpiV6mvEmn1rVOtbDgiM=";
        "8.3" = "sha256-d31f7+Umm5wYoBUpxHHjOD+0PIrduYYn1PZkY+ePt0Y=";
        "8.4" = "sha256-ie3oGmOiPsHrOvnZJQ3hCegP32TMRAZoZkgxMCcHBKA=";
        "8.5" = "sha256-3ZduCECAmIQiA3W0kDf7uVorymmeHTeKrr/RQLWtULo=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-M7L9dhuPXLpje7oOsALotR/eqBQttLWJDWN3XfAHBrA=";
        "8.2" = "sha256-Vv4V6OelFNP4Uk3z6h/48jcOU5Z3Wmc67F/ZyiRs9AI=";
        "8.3" = "sha256-CFM2FxwkxDvAHo+xCGgeCX4EolRCZAx+61CJ9IykoKc=";
        "8.4" = "sha256-syYoJTQgvsPNEcSlQPR83BrMtzaDtw8zT2wQwmR113U=";
        "8.5" = "sha256-6YLj4Po/Y7DQme/owoDVyL0IxyZ3iQTvmn5UtNlI6cs=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-10/hrZDThGl6OH3N3w9PPBnxGXuGc6Tq+pTUGGzq5A8=";
        "8.2" = "sha256-xftL5Jx+bmS3u0c7B05p9mCU43Mff3lSu3IH0fRQ9sE=";
        "8.3" = "sha256-Y2dkOfKdTWIlD6ge7D0CCS0eBbQ9pSwBPwdXtVNZuX0=";
        "8.4" = "sha256-n4OC7ng6RV9i3GcwCHdClUdCA5rKqQfM5XaD43pGY5g=";
        "8.5" = "sha256-k7TWjf3w1dNC7+hdmnOqAJoG3uTt4bkyAWwvL8L2LE0=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-ah+egc41wc2lTrkrStHU6pVxLPk2+9iGG3zSH7Lw0Yc=";
        "8.2" = "sha256-DuTf3Y3XJKcODjtrh6U8otXoPWgyW+IAGpfTthrUycY=";
        "8.3" = "sha256-r2GPfqYfah7LccdQaRCvJAeqDDOVMmkBRJYoOZ4ftEs=";
        "8.4" = "sha256-r8cuauB2ySrFkn6Pq8BwNb0o7CNmWrfEA238rTZD/RE=";
        "8.5" = "sha256-+d+lLxibeqeqrdJv+qpnOBFVt9jI8tko6E/aUQZSJws=";
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
