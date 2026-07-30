{
  stdenvNoCC,
  babashka-unwrapped,
  callPackage,
  makeWrapper,
  installShellFiles,
  clojureToolsBabashka ? callPackage ./clojure-tools.nix { },
  jdkBabashka ? clojureToolsBabashka.jdk,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "babashka";
  inherit (babashka-unwrapped) version meta doInstallCheck;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    mkdir -p $out/clojure_tools
    ln -s -t $out/clojure_tools ${clojureToolsBabashka}/*.edn
    ln -s -t $out/clojure_tools ${clojureToolsBabashka}/libexec/*

    makeWrapper "${babashka-unwrapped}/bin/bb" "$out/bin/bb" \
      --inherit-argv0 \
      --set-default DEPS_CLJ_TOOLS_DIR $out/clojure_tools \
      --set-default JAVA_HOME ${jdkBabashka}

    installShellCompletion --cmd bb --bash ${babashka-unwrapped}/share/bash-completion/completions/bb.bash
    installShellCompletion --cmd bb --zsh ${babashka-unwrapped}/share/zsh/site-functions/_bb
    installShellCompletion --cmd bb --fish ${babashka-unwrapped}/share/fish/vendor_completions.d/bb.fish
  '';

  installCheckPhase = ''
    ${babashka-unwrapped.installCheckPhase}
    # Needed for Darwin compat, see https://github.com/borkdude/deps.clj/issues/114
    export CLJ_CONFIG="$TMP/.clojure"
    $out/bin/bb clojure --version | grep -wF '${clojureToolsBabashka.version}'
  '';

  passthru.unwrapped = babashka-unwrapped;
  passthru.clojure-tools = clojureToolsBabashka;
})
