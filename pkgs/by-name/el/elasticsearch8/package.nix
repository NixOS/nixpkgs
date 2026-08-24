{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  makeWrapper,
  bash,
  util-linuxMinimal,
  gnugrep,
  coreutils,
  autoPatchelfHook,
  zlib,
  jdk25_headless,
  versionCheckHook,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    x86_64-linux = "sha512-hgj4DQNyljGxJ27S8Of+ana/jGA8bNAz+1MSFM5O6qwgMRTk8DojLWBsJIxGUKpx7eu8Zv06qDtK7/1QOEjKNA==";
    aarch64-linux = "sha512-dEBWBGyAtvCPxyGmCQQHFu92LtQGz1gA+3O2nBBBqkyrJp7p6w9bZ0VnkB27Vv9xUssyd47ElhLMZdPl4EGlAw==";
    aarch64-darwin = "sha512-fkNT0mhFQz5G497DieAohC1MpUqHu5jUg3wT8Bk+WBvCcdq9C0tH1XvNJSM3AdFOs5LmJwaUa/rtoDc1GW999A==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "elasticsearch";
  version = "8.19.25";

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

  patches = [
    (replaceVars ./elasticsearch-env.patch { jdk = jdk25_headless; })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R bin config lib modules plugins $out

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
    platforms = lib.attrNames hashes;
    maintainers = with lib.maintainers; [
      kiara
      basvandijk
    ];
    mainProgram = "elasticsearch";
  };
})
