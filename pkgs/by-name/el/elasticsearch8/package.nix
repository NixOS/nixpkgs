{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  makeWrapper,
  autoPatchelfHook,
  bash,
  coreutils,
  jdk25_headless,
  zlib,
  testers,
  nixosTests,
}:

let
  jdk = jdk25_headless;

  platforms = {
    x86_64-linux = {
      name = "linux-x86_64";
      hash = "sha512-7sJ1ELGKP2WOvm4TkK+SJnGFxteY4KXBgmpTGL5n9ctjjpg8E0OUom2D7o0hWK8f7vD4MFv4+oycKKcAX7DaDA==";
    };
    aarch64-linux = {
      name = "linux-aarch64";
      hash = "sha512-s0mw5l9s3GFrjD6+R9FBNLjT3Oh7dsmztwHbIlMWm7batNT/qHwxFJid/jA0IeKgy5ES16t08aUQVBtI76h1mA==";
    };
    aarch64-darwin = {
      name = "darwin-aarch64";
      hash = "sha512-7OOUxCG1/wkdu2ffsWOSl4y2pk+sDVfHK6mK+Cmh0iKk4/FhC6rr1agc7m/cLbDgVNqvlQaG0XdnBS72S4aQ2Q==";
    };
  };

  platform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "elasticsearch8: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "elasticsearch";
  version = "8.19.24";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${finalAttrs.version}-${platform.name}.tar.gz";
    inherit (platform) hash;
  };

  patches = [
    (replaceVars ./es-home.patch { inherit jdk; })
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = [
    bash
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R bin config lib modules plugins $out

    # Only wrap the server launcher: the other CLI tools derive their name from $0
    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}

    runHook postInstall
  '';

  passthru = {
    inherit jdk;
    enableUnfree = true;
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      inherit (nixosTests.elk.unfree) ELK-8;
    };
  };

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage = "https://www.elastic.co/elasticsearch";
    changelog = "https://github.com/elastic/elasticsearch/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.elastic20;
    platforms = lib.attrNames platforms;
    maintainers = with lib.maintainers; [
      basvandijk
    ];
    mainProgram = "elasticsearch";
  };
})
