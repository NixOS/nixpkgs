{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  makeWrapper,
  jre,
  lib,
  zlib,
  callPackage,
  runCommand,
}:

let
  pname = "bloop";
  sources = lib.importJSON ./sources.json;
  inherit (sources)
    repo
    version
    assets
    completions
    ;

  platforms = builtins.attrNames assets;

  fetchAsset =
    { asset, hash }:
    fetchurl {
      url = "https://github.com/${repo}/releases/download/v${version}/${asset}";
      inherit hash;
    };

  bloop-binary = fetchAsset (
    assets.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}")
  );
  bloop-bash = fetchAsset completions.bash;
  bloop-fish = fetchAsset completions.fish;
  bloop-zsh = fetchAsset completions.zsh;
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  dontUnpack = true;
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    zlib
  ];
  propagatedBuildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 ${bloop-binary} $out/.bloop-wrapped

    makeWrapper $out/.bloop-wrapped $out/bin/bloop

    #Install completions
    installShellCompletion --name bloop --bash ${bloop-bash}
    installShellCompletion --name _bloop --zsh ${bloop-zsh}
    installShellCompletion --name bloop.fish --fish ${bloop-fish}

    runHook postInstall
  '';

  passthru = {
    updateScript = {
      command = lib.getExe (callPackage ./update.nix { });
      supportedFeatures = [ "commit" ];
    };

    tests.help = runCommand "${pname}-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
      export HOME="$TMPDIR"

      # Anything that reaches the build server, `bloop --version` and
      # `bloop about` included, downloads it from Maven Central first and so
      # cannot run in the sandbox. --help is answered by the native client
      # alone, and still exercises the patched binary and its wrapper.
      bloop --help > help.txt
      grep -q 'Interact with Bloop' help.txt
      grep -q -- '--java-home' help.txt

      touch $out
    '';
  };

  meta = {
    homepage = "https://scalacenter.github.io/bloop/";
    changelog = "https://github.com/${repo}/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    description = "Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way";
    mainProgram = "bloop";
    inherit platforms;
    maintainers = with lib.maintainers; [
      agilesteel
      kubukoz
      tomahna
    ];
  };
})
