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

  version = "1.92.43";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-KfmaqLh4wGu7hV+JzsvUms3cWc9Cop0dkBUzHjMsWec=";
        "8.2" = "sha256-FdE5zadL6eFZtN0/XRdO9iODC2VrjPTaHEcJZTurf94=";
        "8.3" = "sha256-V7OY4dIqB88lMD06VYs7OuC2yHTSpik2OR26jlebOt0=";
        "8.4" = "sha256-RMxQva3n5o/I/mX8Gzn1kStRKryP89Jx3/t+5ygZSPs=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-y+C5//euPCMZQ9u4nMJedEJLnLvhM0IZiVMS4eqKV+U=";
        "8.2" = "sha256-ZmFcH1RtPZD/G94fV0GR/AJ3D/ib/eXY8hg/GGu5csM=";
        "8.3" = "sha256-+vRcRLgFm62+k1ZKr5wxOAfRx2vvt3qET9fe7k3Rt9g=";
        "8.4" = "sha256-PwhTwNVuAuNhKWZxm+uk4/KHRFDNg48nEAvrlh57PPg=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-purtoxmmpKkZ1CpHNjK+wXNIHoayqOiWA7NvA/IJLpQ=";
        "8.2" = "sha256-SlGeu7AX/ReEixqjSFuQ2YR1r8oHOvvRI5WsNu8GWyM=";
        "8.3" = "sha256-Kb2PWngBKy7QjIj2TMFqOaRZto68xxKu9RnD2dmdwlM=";
        "8.4" = "sha256-udoUmOpzTwLaGUB/fTSX4me+n84WtT0cKLRLZXR3FA8=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-7OMHzp8hXqiPxa7UcbUwtVG562KPcsXm9A2b3E3p1Ec=";
        "8.2" = "sha256-Vo2ghIEa1D9Kn7bm9ocXARXLmA+iUJIdNRpCUIoYWIQ=";
        "8.3" = "sha256-AY3QXAjEmK2Ni+VUcIWhdRiCZta7/I4G9ce+p8/EKBw=";
        "8.4" = "sha256-S5IpFqBADWAJ5IbE/qoSZQuuQMfktEIV4F6fJStXono=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-pUl6dAJ6+CR/bJmy3Z8g7h+V4oLq6BwSqnt1cWYwlr0=";
        "8.2" = "sha256-T7wXhkowkjM8dUCTPJLF/oIGRz5fRqPC55eaUDHN20g=";
        "8.3" = "sha256-Qvi9mdCgaK+dUCzwHGCT7taFkj6/hZn/1GKib7z0PeY=";
        "8.4" = "sha256-CC+6xLuZuXEy3yT/teyIZmWBtKfELiAE6tqEZRlwV60=";
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
    maintainers = with lib.maintainers; [ ];
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
