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

  version = "2026.8.2";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-zpnLTspWHuO6DYID3onrtosckuXZxGakwOYeKhavEyQ=";
        "8.2" = "sha256-782HlpvbAOXmHDSngzKaxtHIm0D7GvY9+YEFR9zyTLA=";
        "8.3" = "sha256-mqfWlShiXcYdsXRTwyOT6fRmY5p/JohnlyKym2GCwrA=";
        "8.4" = "sha256-rTCcUxw5Tofo2Qm+Be9tfDpPdc0+8JAUdALSYl2ik5Y=";
        "8.5" = "sha256-kycVZToRg0hDQCPZsJ/L1EMl2p+OCPEqBg8RYf5Shbo=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-dyvSF/rBSZcE6gyHXskDA0nwfqFcsCzsFnlRPKxvAMI=";
        "8.2" = "sha256-Wb25lOI3WXXShMVOijoRVFHTIH/dZ9c5TayJeekTCcQ=";
        "8.3" = "sha256-RhZMLKJUTpBgSFcdzd3p34eOMaodDI5khOcUER51h/s=";
        "8.4" = "sha256-nJ9IObJAXB7c7QKPq7lGXjogcb7ebnDiqOA1MjFSiWQ=";
        "8.5" = "sha256-g5bbSaRwm7G2Qxit5RPLGPmTYo648egLTzXhmd1RwOw=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-l7nF5WYzA8SaXW8vrCSNNSdkQU9+UBqJypKNak4Mp0A=";
        "8.2" = "sha256-/SnDc4r/okZqc7E1WBxBjBv84wcY/zegcap0NhZDxLc=";
        "8.3" = "sha256-pRYwzhovP/pZm2S4Z6Roub1/vkq8N0XkNBC+ubtLoj8=";
        "8.4" = "sha256-uI5KPDlaF9tSd0oW8Z3PkHJgu4o+YbHPfwRZdZl62RU=";
        "8.5" = "sha256-XCg7axeUuIku9yX4UYQAGaW2scNymz+TQDbX23/ZOC0=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-3Ekt/FENfFlw9mPDC2/tdBQcrz4Pt6rW7PqXAyb60+8=";
        "8.2" = "sha256-rBuODppr5Bwmvo678j4wSBjOCh5tNGroVps2OORhvwU=";
        "8.3" = "sha256-47uRupplRV1ALufv7t1mGXkDAtj4KCUwBLPo16ui8vs=";
        "8.4" = "sha256-Exl3sg3R7b7TnUSnWH4EcgwWa6AXZlt4Y1MyGY4ul5E=";
        "8.5" = "sha256-9RGvzW5v41quSTrphCHHFPvFw5/616tsfIpB/urL75I=";
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
