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

  version = "1.92.38";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-W8VlvHa6vmNbDX5r5FG8pB0vpXRn5hPu61td9aARecA=";
        "8.2" = "sha256-f3AKwh9mUCoFDaXM+EwTORk0/TFyArtEa+sv7cMZmDs=";
        "8.3" = "sha256-6zigke1VY439IIxrQg5Dxcggn+7Q0BE/spPycvxdyik=";
        "8.4" = "sha256-n89OCTUGsWhpc61P9WvKyjdJ52wJHoj6NEb2mcs0whA=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-31lJOGL9i8kL22zH8zzYZtxB94ssJiw+qXQRmQilR+c=";
        "8.2" = "sha256-f+D7DZvLQk6ebLfJ43qFSqWzU6YQoP/7nVGajLRll5g=";
        "8.3" = "sha256-56/+604Vymb+otL7oria3d/w4b1o8Pt199aXK4nfJC4=";
        "8.4" = "sha256-K26Dy0S9w0uWTX7GkIjh0jUtaa768B+ls9gq8LXNZUA=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-aSjOxMZdP+Lrd4FaXgkbHykmKBn9WuzGumrYpJEKpS8=";
        "8.2" = "sha256-ckhHA/EYeRlhSrc5nMUl6jS0iAaW1q1sZAYYxjcGOwQ=";
        "8.3" = "sha256-p3P94uPTbekbxgICuC72NEA5XFpYng2MZI+9L+0R/Ew=";
        "8.4" = "sha256-KCMRNpS2A5Tb5Td8fpBusu70FNIOfJ+6pYRUgw/5kDg=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-5JPn9lNsh6NJemCRmrBrTIvhEUQfjmIGbASaoiKoZDo=";
        "8.2" = "sha256-e9tsXi3SML9HZ81XD5LhGcm7L8Ag9fOvyTo0Gy42YRw=";
        "8.3" = "sha256-RCmYyrcSi7hfkbGOSp8ywFkm1IFGy0bgu8tmdrTID6c=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-SuD9iDjxMBt2GZtDXPIjCCl1mEt9K2GciuC7S9ppNZQ=";
        "8.2" = "sha256-om1L/VQiwdV4D2awuz98ko7Oz9h1GYRtqYZrQRZpy7E=";
        "8.3" = "sha256-H1xkneOLk7DCPqtbknLlQX2iKe/U6/ilmToOOtiRabs=";
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
