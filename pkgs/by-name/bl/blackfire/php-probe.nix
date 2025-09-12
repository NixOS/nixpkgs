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

  version = "1.92.42";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-vj/Z7fGQqUfWOpCi2TV4tiu2LCdTPhUJXeinL09LgeM=";
        "8.2" = "sha256-K1h0fH9PH/LT+8EecJ0GTJxpuc4hszG9mbcvNc/6bEs=";
        "8.3" = "sha256-U0meas8ZMPnlDuMsMoGLYBZsRBrrSmTSuryhFRmzZ/4=";
        "8.4" = "sha256-znvTd6QR+rfRQG1w0SEWgEDxzBWiVWOf7VH25b2Sryo=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-B2FcYKVz4sDSUlI5QifUCbX7XZME2XqaAhUVnHH+C2s=";
        "8.2" = "sha256-k6C7Wl9O0icBQjYOjO0Hy0NitKbM9TOxTV0F4OM04LQ=";
        "8.3" = "sha256-4EaRYLJ1I7oH0Ux1/IrOD67iWVKx9GU1uMVUA0AwrRk=";
        "8.4" = "sha256-aNcl27Do6NoCuUHiFeDwTSVU1m0imxrMR+yiyq7/owQ=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-5PcD4HnlZmgkP+fsZhBaDGbDQCoQ/Om3om3cpouTF8s=";
        "8.2" = "sha256-wIa2Yv4q0d3jtNvMAFTq8d3Gznl88uhqyvCBtwJtMkY=";
        "8.3" = "sha256-Fwhv7rVGsmXFcBR5E17S4tt1mEzYlxbzaz996sqbwxs=";
        "8.4" = "sha256-ftsKeJ/TOJAavNt8VGSzJR+Bo/KcW+o5Dym2flbHxag=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-MR4Icjufw5dSxRKv1gJPP38Vow+PZp2/OofKOGkr/Nk=";
        "8.2" = "sha256-RRwF0NKhGxZH0SNOGzr2eVg6ZDDThNgd9HBgv+Q9wCw=";
        "8.3" = "sha256-91uv7sxf19+12/Rja1SehbIKBiE+teZv+F0lOi7KUEQ=";
        "8.4" = "sha256-v4SnkF4DtPpB5TBiSnJYJs+KRI5IpIcKeQECVCrkdLw=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-HzBzT8pTsc/iIMDcEQlb24f8EIYdhRqxKjb7FxB6OaY=";
        "8.2" = "sha256-Tr9quIzQWmSMHpvZ18u2OoCP16CHpcbWxKyZeY4zJJM=";
        "8.3" = "sha256-PmPxE29qwHJKSaTdoZQiJcwobkDMKMEcEB8ZZWFonb4=";
        "8.4" = "sha256-f+Hn9yCtaDmWendB85ca4+6xd9eG3y+5tLTV7Qi9lPA=";
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
