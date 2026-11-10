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

  version = "2026.11.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-a77g9Eu+6t0CdJL6mm2FbLxZ3ncaxW53cyAeZLm4yYU=";
        "8.2" = "sha256-EioQ6+f6m4GLBzoaKZGW7neaMCsHzO6wErfRa1wgRv4=";
        "8.3" = "sha256-yMjvCjsxaGMEidQaECGjeUkA4MOpq1gEp2rw7bZzwmE=";
        "8.4" = "sha256-aAaz542yyUfqQQMITl82xi6Doe7fzPjSGEoP8CNGIG4=";
        "8.5" = "sha256-Mf/vCm7AEZR+fWUQQzJElyPFs545HW61OapwKI79Kj4=";
        "8.6" = "sha256-r9WKxJ/eWdqkxUKNokw4LLMx1URh5LytlgXxk5F6DD8=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-OKJGdrflQqz463BDiVlNbQaXkomWG3pQtqmN1L4TZGw=";
        "8.2" = "sha256-tYN1y+3QAjHLpWO0s+FSxn6Nj6p15RqmG3+D9m27mOo=";
        "8.3" = "sha256-wwJqEZlhmfNu8ABwYsT8PvvQUeZsMgpLQMntlIGB62U=";
        "8.4" = "sha256-VFvR8wrYRzS2SYxL1Bpqj6/KerqX56O+7WePo6P82W0=";
        "8.5" = "sha256-+1SH9A+iec2PLjh+yGJ9M/x9LVL/Et5lzeu4DeoZn/4=";
        "8.6" = "sha256-p82Bi6RHJD8j56TIXiaXCU/hxeA+KnkzmgkR3va2fY4=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-T+ZreRvkUmL/I+LqlGGIoU2cCNTPNmrqJ/JYx8bQ9t8=";
        "8.2" = "sha256-zjsX1cS0vKjecTVV8b767HOZD4AWfxzEg03xlW0w8fM=";
        "8.3" = "sha256-74jOnIWTQYHcZc7K3vM8HwomQegA0basvZATVxJUOWE=";
        "8.4" = "sha256-CYvfNAYZ26lrgpzMkwvyy7RQDRZKhIpwJZC4+yvJEF4=";
        "8.5" = "sha256-2haQWK9IBRl0r6fXLV3xdy6Tl6NZgqm4/30YeFakI5c=";
        "8.6" = "sha256-ICRDAfeB417ZpdqS3IsJaenXVi4z+5ZtIOdm29ILYWY=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-H7pWwychp2TEqIyeLAfkyQE2JY1mpkWrppVwI3so5cY=";
        "8.2" = "sha256-REfRTS7lqvW7dqFCsChQ+L4iRF1lU+H2A+tRKkL/JOE=";
        "8.3" = "sha256-AvBUgG9NpFGMH8byTS60CUExtRXT7BoPI1IAOms5hGM=";
        "8.4" = "sha256-GrGnrgZSdV5NkRfW5ruZV7yCzj4UWUpX9cgE1fLe7Us=";
        "8.5" = "sha256-8q/ixJYkLXRTOlK90cTc7Jge2TTEaHdIz9C4T1ugJxg=";
        "8.6" = "sha256-UXalrvu8KASw8aO21sapWfkg/kPiwcFF2ERUBhSXqiU=";
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
