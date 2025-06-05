{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  gcc-unwrapped,
  zlib,
  lttng-ust_2_12,
  icu,
  openssl,
  makeWrapper,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    _supportedPlatforms = {
      "armv7l-linux" = "linux-arm7";
      "x86_64-linux" = "linux-x64";
      "aarch64-linux" = "linux-arm64";
      "x86_64-darwin" = "osx-x64";
      "aarch64-darwin" = "osx-arm64";
    };
    _platform = _supportedPlatforms."${stdenv.hostPlatform.system}";
    _dirName = with finalAttrs; "duplicati-${version}_${channel}_${buildDate}-${_platform}-cli";
  in
  {
    # TODO build duplicati from source https://github.com/duplicati/duplicati/blob/master/.github/workflows/build-packages.yml
    pname = "duplicati";
    version = "2.1.0.5";
    channel = "stable";
    buildDate = "2025-03-04";

    src = fetchzip {
      url = "https://updates.duplicati.com/stable/${_dirName}.zip";
      hash = "sha256-Oy/GJlH7pTz5yTXGjtE7G82TCcURrsQYbeRnU+XaMvI=";
      stripRoot = true;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];
    buildInputs = [
      gcc-unwrapped
      zlib
      lttng-ust_2_12
    ];

    installPhase = ''
      mkdir -p $out/{bin,share}
      cp -r ${_dirName}/* $out/share/
      for file in $out/share/duplicati-*; do
        makeWrapper "$file" "$out/bin/$(basename $file)" \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            icu
            openssl
          ]
        }
      done
    '';

    meta = {
      description = "Free backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers";
      homepage = "https://www.duplicati.com/";
      license = lib.licenses.lgpl21;
      maintainers = with lib.maintainers; [
        nyanloutre
        bot-wxt1221
      ];
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      platforms = builtins.attrNames _supportedPlatforms;
    };
  }
)
