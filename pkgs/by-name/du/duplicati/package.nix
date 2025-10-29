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
  makeBinaryWrapper,
}:

let
  _supportedPlatforms = {
    "armv7l-linux" = "linux-arm7";
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
  };
  _platform = _supportedPlatforms."${stdenv.hostPlatform.system}";
  # nix --extra-experimental-features nix-command hash convert --to sri "sha256:`nix-prefetch-url --unpack https://updates.duplicati.com/stable/duplicati-2.1.0.5_stable_2025-03-04-linux-arm64-cli.zip`"
  _fileHashForSystem = {
    "armv7l-linux" = "sha256-FQQ07M0rwvxNkHPW6iK5WBTKgFrZ4LOP4vgINfmtq4k=";
    "x86_64-linux" = "sha256-1QspF/A3hOtqd8bVbSqClJIHUN9gBrd18J5qvZJLkQE=";
    "aarch64-linux" = "sha256-mSNInaCkNf1MBZK2M42SjJnYRtB5SyGMvSGSn5oH1Cs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  # TODO build duplicati from source https://github.com/duplicati/duplicati/blob/master/.github/workflows/build-packages.yml
  pname = "duplicati";
  version = "2.1.0.5";
  channel = "stable";
  buildDate = "2025-03-04";

  src = fetchzip {
    url =
      with finalAttrs;
      "https://updates.duplicati.com/stable/duplicati-${version}_${channel}_${buildDate}-${_platform}-cli.zip";
    hash = _fileHashForSystem."${stdenv.hostPlatform.system}";
    stripRoot = true;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];
  buildInputs = [
    gcc-unwrapped
    zlib
    lttng-ust_2_12
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r * "$out/share/"
    for file in $out/share/duplicati-*; do
      makeBinaryWrapper "$file" "$out/bin/$(basename $file)" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          icu
          openssl
        ]
      }
    done

    runHook postInstall
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
})
