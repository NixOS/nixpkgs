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

  version = "2026.7.1";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-nkLVqnzw63ZftmVE1KWDPDSaiNkk8v9I+D1EipS6eYA=";
        "8.2" = "sha256-PbZrm6fV28D4oyUW+OgRINK5ySJdnXO/ZBTliPtb4c8=";
        "8.3" = "sha256-Yhl0UTQyQaUbMD3XAmzxqsmjxMRl2gr9S17SpFrTGto=";
        "8.4" = "sha256-nR/um5sD0qrU91FCB3uYMqBc50IKGwsBwenJ9mSFpRA=";
        "8.5" = "sha256-QzvH/VZ2SFSw5wioKMcM1nqcyOZq2Z1q6z3z0H/l3KE=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-MQBYuc3KSozbI4WPslsqWC8XwHeOOAZ46OlVxqwsNdk=";
        "8.2" = "sha256-bJiDWWZlnHtXNg67bWjgpew5o8LIuFEPGvI5Ziooi+U=";
        "8.3" = "sha256-WpRKROLWscmr7+IDqFpvEheaW5l2AEtCFfy46JTdHPw=";
        "8.4" = "sha256-mMLPqB7U8iUtJbFxAOGU6ZEUd2AzFd0EeDScy1zmfwk=";
        "8.5" = "sha256-472Bm0y/kJT75IEfno2LSG+dPDF6ODKEJURWWTQg0Fo=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-16A1dICRcNMorBAKHvD9YK6oddmrfiOy3hrHpW2KfpA=";
        "8.2" = "sha256-Y1+CEIGQHWPNfaXevTNNiOyeV2HwX+od277s+FNsTiM=";
        "8.3" = "sha256-PrFcGI8RlhO54jDgqpdl+he8ly+nSUVHbX6zQDLuKtA=";
        "8.4" = "sha256-HETb8SSeDITKaeazk8K0acZkEQUzIqVnS6F6ZBqbSSo=";
        "8.5" = "sha256-cyuHH9X3w9d4tCSKDUqaYz8Cq0z0nQFZHIR9U1CMQl4=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-IYKuYK4jLavOEmtvt/21m5u/BNuWQKQvqPcVYx4XEmE=";
        "8.2" = "sha256-uitcd/WSs089ADBd5oEyJS7HObTY2N+e7CGrVy72fSE=";
        "8.3" = "sha256-z6vDJ/k9acNM9HnQOL4OeaaQpjf/g9F85iwKHZdeCkw=";
        "8.4" = "sha256-BzNouJIeKGzHG3rxf8u4TUOH/3mfjl4oJAdtkQbxu3Q=";
        "8.5" = "sha256-XGgRPF4PpgOa3ZjGVIyYTZXrd0bOayek+zK6L9ZUyv4=";
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
