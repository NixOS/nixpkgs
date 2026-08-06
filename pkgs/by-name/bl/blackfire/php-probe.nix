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

  version = "2026.8.1";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-EorgMVcp3S5OpfIgUEduNxrt08sWJSvLewWPo7dogV0=";
        "8.2" = "sha256-J0DwpOKRCGJPyeAz9xIJv4Abe6E4nnbR3yt5/r5kiuY=";
        "8.3" = "sha256-HL/c1IDp9352oEWtwF6F8WuIVMYRnutvB3qw44F7wNc=";
        "8.4" = "sha256-Mz1JzESM8ieBbFPvUNVto8vZCm+nNxF8p2/MCbjQGtY=";
        "8.5" = "sha256-vl2jiWwx+76mID1QEyKyMmN36aQ06xIoo+EqNB9K9AI=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-aGu3mxpOdvzhGBXG9ZgfwbMKTk86AKlyq9NsbVJZwTg=";
        "8.2" = "sha256-WLzaT/UOPgBd1Rg7emGyD9ZAZ2jErfQGGhLsACnZ1vM=";
        "8.3" = "sha256-H8cAeBsMyPD3NB0Ygy4Hqtlo68jdiZoDaEMzdRO8EPQ=";
        "8.4" = "sha256-D5e5c5s7ZpkHtxCxxx4cK5nG5+v5U/h4sEn/j2fNZwo=";
        "8.5" = "sha256-pyPE2icBXTeYVSSqa+CgEOtOH8v6+h93FnZN8SCiZHQ=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-M21FKr3CkFiDpZYTi4n1yZMfXSJvhqOn5/egjyFoAkM=";
        "8.2" = "sha256-hyGRFpl/9nCXHiIHsbZCoL9J7ngB93tB8610GbnOX0U=";
        "8.3" = "sha256-5KnsPaZTsixF4wgeTRVh3mgrYrTY9W8SxW8Nq9ete0w=";
        "8.4" = "sha256-kxc+zyBZxuWTV1i4dcYf8P4P7X4/ByV8EBedxW++mGw=";
        "8.5" = "sha256-A/rWoX7ag/df8tbhp6PEU7neVrQaTbNP2n+ZJZvuJhc=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-9T8wsKrfHQJbskJJHdrrb6S6bGPB1Rwl6cwdycC1JvM=";
        "8.2" = "sha256-uro6/a3LNi/vR5Fu6e8XLjhMR++6EubPTIUc3w/yk0U=";
        "8.3" = "sha256-GTJ1CNnKJRkHWkVHWL78ZooFEoZoXYlB299RdxSnPTc=";
        "8.4" = "sha256-G6jVxG1muNy5D64b9nrF/7rQQD3yDEYQUhZUZyAy3qw=";
        "8.5" = "sha256-61LxJlg+uIaEJzE29LWkn5hSLVVmn0/yUkZIpKXPbsc=";
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
