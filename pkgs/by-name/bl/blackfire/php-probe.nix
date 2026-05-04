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

  version = "2026.4.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-jvEK8wySXe1dxoIr8+bmT4wLG3qsZjrjo3EPt1B+/Y0=";
        "8.2" = "sha256-E1fa0ZTGUP8RJ31TToC8mkgOTP7aqXEkmteaqHWyf8k=";
        "8.3" = "sha256-/YHIia4j9KN1C6QW6cHPNZQIr8fLhG8ckgn5crxYGSs=";
        "8.4" = "sha256-7Fw0JuiLQafjGFSBn4nPh/zOcGs+W9KTF2GlZxEzmpo=";
        "8.5" = "sha256-jP/NOn/vqsSjyzpbR7p3EEhemki9XlmdbxOiE4cneNY=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-lwnWMwcJcn6Rm5bC2+XupQKg+CMw2gmOP2ovEHxtlh4=";
        "8.2" = "sha256-2uAuNTWVJDe5s5NMQcC3108qbylB7tU9cDiN2gKHt4k=";
        "8.3" = "sha256-+mDy4vfEK2LvcISDg2VEgWHlQpjczZBUy1uH6K5jfsw=";
        "8.4" = "sha256-WlyPIekNx7IMYowegklJK59i8Dx5+uCUDIfoa21DC0s=";
        "8.5" = "sha256-dRrK4PTwsw1WC0d+1YYXcaBliK0z+90JIcF/VkDJxeY=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-35RJWjICtqK4zNpo8Ufgk+Ulhg+Ff+hj+ZMmxzXvOZc=";
        "8.2" = "sha256-ygbDD2EIWKWL3ln0i5nvN+ZcX888QuB0RNtfgVAnKsM=";
        "8.3" = "sha256-A7zYx2Q/bsYKPIJ6AYvbW3jYTa0QTYlwkdKJcq3/mwk=";
        "8.4" = "sha256-v/JipaVLm4Z2ytGgrxML1vLed/o/Vv7BevualOOKyN0=";
        "8.5" = "sha256-ACSEvrkHjKqSKmVdglDCNQvLOCxP+x7z5+41d5H/JO0=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-V2b+IS9R7+1U+noawxGX/dPclYT3qE6LGszDvo/4eWE=";
        "8.2" = "sha256-+xoLdnZBVlmWO00mM9HmaEYVfMkxoRKpZwUAdJ/PKkM=";
        "8.3" = "sha256-G/6oKjmX5ATz1HS1o0dEhpQ4sl0oQDYy2DrJNmUusIY=";
        "8.4" = "sha256-y/8BL8T3tjMKwvcOoMF6T6jz1ia0DxlBK/v3GamKiAw=";
        "8.5" = "sha256-P749lxXFQZU4zMKof3JMuCAEhVMADrBU4r3QvLQnZ7s=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-KG2UCgydD/ZSdLa9q8ozQ6y7UbUVumvaVg1SkI/5veI=";
        "8.2" = "sha256-6iSCXxItzUJs0Gz7A7NSOk+9kJqnskgTXPzSFle7+8A=";
        "8.3" = "sha256-37xrzBtrdHIBTquCjnM8ndd+f04nbi7muneN9AgG7Q4=";
        "8.4" = "sha256-J/DqPCJcvXtAuRmeeFyWFDUIXzYIvH7Yva0BTuLew2o=";
        "8.5" = "sha256-6gP86Dgklohh9/FBBHn2a21bgGb7Ro2ZeOy60P/4QF0=";
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
