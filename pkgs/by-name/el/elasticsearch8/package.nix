{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  util-linuxMinimal,
  gnugrep,
  coreutils,
  autoPatchelfHook,
  zlib,
  versionCheckHook,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-b/zOj+RtJbA1s5ECYxCX8qMR5H1AaZGTKyUk09S7MJx0CopNMRNZCfyC+Mfkl8PCxUTM9Y6VdeIAxqAYPtisZg==";
    aarch64-linux = "sha512-2Jxi5FdstVf3gLiPmwdUPq0zxRK+Zjs0qj/FkH6HIJp9jwvs7dGBhimKZKEwgUiD+xeSLogGhFjYXfADHSM6hw==";
    aarch64-darwin = "sha512-7iwjKUk51HXejQi6kBKqHQAAntg8uHWPb5fjm2c3heAd8rEZcpy1Jmt4kUuvSXLFPOsfXB+c5TFAuHbqsWMvmg==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "elasticsearch";
  version = "8.19.16";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${finalAttrs.pname}-${finalAttrs.version}-${plat}-${arch}.tar.gz";
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [
    bash
    util-linuxMinimal
    zlib
  ];

  runtimeDependencies = [ zlib ];

  # Only the GUI and sound libraries of the bundled JDK use these.
  autoPatchelfIgnoreMissingDeps = [
    "libX11.so.6"
    "libXext.so.6"
    "libXi.so.6"
    "libXrender.so.1"
    "libXtst.so.6"
    "libasound.so.2"
    "libfreetype.so.6"
  ];

  patches = [
    ./elasticsearch-env.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    # The entitlements agent of Elasticsearch only works with the bundled JDK.
    cp -R bin config jdk lib modules plugins $out

    chmod +x $out/bin/*

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${
        lib.makeBinPath [
          util-linuxMinimal
          coreutils
          gnugrep
        ]
      }"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license =
      with lib.licenses;
      OR [
        agpl3Only
        elastic20
        sspl
      ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      kiara
      basvandijk
    ];
    mainProgram = "elasticsearch";
  };
})
