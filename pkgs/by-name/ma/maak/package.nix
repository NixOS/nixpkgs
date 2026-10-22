{
  lib,
  stdenv,
  fetchFromCodeberg,
  gitUpdater,
  bash,
  coreutils,
  guile,
  makeWrapper,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maak";
  version = "0.12.2";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "maak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L9OTTOpkp5Y4iO+pviymNpWQQ8WwfSjl4cm2GlmUI/Y=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    guile
    makeWrapper
  ];

  buildInputs = [
    guile
    coreutils
    util-linux
    bash
  ];

  buildPhase = ''
    runHook preBuild

    siteDir="$out/${guile.siteDir}"
    ccacheDir="$out/${guile.siteCcacheDir}"
    mkdir -p "$siteDir" "$ccacheDir"

    # Install the library sources, then byte-compile every module so that a
    # consumer does not pay for it at run time.
    cp -r src/maak "$siteDir/"

    export GUILE_AUTO_COMPILE=0
    export GUILE_LOAD_PATH="$siteDir:$GUILE_LOAD_PATH"
    export GUILE_LOAD_COMPILED_PATH="$ccacheDir:$GUILE_LOAD_COMPILED_PATH"

    pushd "$siteDir"
    while IFS= read -r scmFile; do
      goFile="$ccacheDir/''${scmFile%.scm}.go"
      mkdir -p "$(dirname "$goFile")"
      guild compile -L "$siteDir" -o "$goFile" "$scmFile"
    done < <(find maak -name '*.scm')
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 scripts/maak "$out/bin/maak"
    install -Dm644 resources/help.txt "$out/share/resources/help.txt"
    install -Dm644 man/maak.1 "$out/share/man/man1/maak.1"

    install -Dm644 scripts/maak-completion.bash \
      "$out/share/bash-completion/completions/maak"
    install -Dm644 scripts/maak-completion.fish \
      "$out/share/fish/vendor_completions.d/maak.fish"
    install -Dm644 scripts/maak-completion.zsh \
      "$out/share/zsh/site-functions/_maak"

    wrapProgram "$out/bin/maak" \
      --prefix PATH : "${
        lib.makeBinPath [
          guile
          coreutils
          util-linux
          bash
        ]
      }" \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # `maak --version' reads no Maak file, so it answers anywhere: the check
    # asks from an empty directory rather than from the unpacked source, so a
    # version probe that started demanding a Maak file again fails here
    # instead of in somebody's script.
    emptyDir=$(mktemp -d)
    (cd "$emptyDir" && $out/bin/maak --version) | grep -F 'maak ${finalAttrs.version}'

    runHook postInstallCheck
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Command runner à la Make using Guile Scheme";
    longDescription = ''
      Maak is a command runner and control plane for your projects.  It allows
      you to use the power of Lisp (Guile Scheme) to define your tasks, build
      steps, repetitive tasks or other automation.

      With Maak you can easily call external shell commands and integrate with
      your existing scripts and tools.  It is inspired by the GNU Make utility
      but it does away with a lot of the complexity that comes with its
      history.
    '';
    homepage = "https://codeberg.org/jjba23/maak";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jjba23 ];
    mainProgram = "maak";
    platforms = lib.platforms.linux;
  };
})
