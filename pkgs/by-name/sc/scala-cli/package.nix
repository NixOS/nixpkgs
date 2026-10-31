{
  stdenv,
  coreutils,
  lib,
  installShellFiles,
  zlib,
  autoPatchelfHook,
  fetchurl,
  makeWrapper,
  callPackage,
  jre,
  testers,
  runCommand,
  zsh,
  fish,
}:

let
  pname = "scala-cli";
  sources = lib.importJSON ./sources.json;
  inherit (sources) repo version assets;

  platforms = builtins.attrNames assets;
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
  buildInputs =
    assert lib.assertMsg (lib.versionAtLeast jre.version "17.0.0") ''
      scala-cli requires Java 17 or newer, but ${jre.name} is ${jre.version}
    '';
    [
      coreutils
      zlib
      stdenv.cc.cc
    ];
  src =
    let
      asset =
        assets."${stdenv.hostPlatform.system}"
          or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/${repo}/releases/download/v${version}/${asset.asset}";
      inherit (asset) hash;
    };
  unpackPhase = ''
    runHook preUnpack
    gzip -d < $src > scala-cli
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 scala-cli $out/bin/.scala-cli-wrapped
    makeWrapper $out/bin/.scala-cli-wrapped $out/bin/scala-cli \
      --set JAVA_HOME ${jre.home} \
      --argv0 "$out/bin/scala-cli"
    runHook postInstall
  '';

  # We need to call autopatchelf before generating completions
  dontAutoPatchelf = true;

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      autoPatchelf $out
    ''
    + ''
      # hack to ensure the completion function looks right
      # as $0 is used to generate the compdef directive
      mkdir temp
      cp $out/bin/.scala-cli-wrapped temp/scala-cli
      PATH="./temp:$PATH"

      installShellCompletion --cmd scala-cli \
        --bash <(scala-cli completions bash) \
        --zsh <(scala-cli completions zsh) \
        --fish <(scala-cli completions fish)
    '';

  meta = {
    homepage = "https://scala-cli.virtuslab.org";
    changelog = "https://github.com/${repo}/releases/tag/v${version}";
    downloadPage = "https://github.com/VirtusLab/scala-cli/releases/v${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    description = "Command-line tool to interact with the Scala language";
    mainProgram = "scala-cli";
    maintainers = with lib.maintainers; [
      agilesteel
      kubukoz
    ];
    inherit platforms;
  };

  passthru = {
    updateScript = {
      command = lib.getExe (callPackage ./update.nix { });
      supportedFeatures = [ "commit" ];
    };

    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "scala-cli version --offline";
    };

    tests.completions =
      runCommand "${pname}-completions"
        {
          nativeBuildInputs = [
            zsh
            fish
          ];
        }
        ''
          share=${finalAttrs.finalPackage}/share

          bash -n "$share/bash-completion/completions/scala-cli.bash"
          zsh -n "$share/zsh/site-functions/_scala-cli"
          fish -n "$share/fish/vendor_completions.d/scala-cli.fish"

          # postFixup generates these by running the binary, which puts $0 in the
          # output; without the PATH dance there, these would name a store path.
          if grep -r /nix/store "$share"; then
            echo "the completions above name a store path instead of scala-cli" >&2
            exit 1
          fi

          touch $out
        '';
  };
})
