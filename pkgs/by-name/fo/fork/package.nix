{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  callPackage,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fork";
  version = "2.66.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://cdn.fork.dev/mac/Fork-${finalAttrs.version}.dmg";
    hash = "sha256-80T545Q80J+Dri62bj42CxUExO7HC/ihhf9tgU9i8Q0=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r Fork.app $out/Applications/
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s "$out/Applications/Fork.app/Contents/Resources/fork_cli" "$out/bin/fork"
  '';

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });

    tests = {
      help = testers.runCommand {
        name = "fork-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          fork --help | grep "Fork Command Line Tools"
          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "fork";
    description = "A fast and friendly Git client";
    longDescription = ''
      Fork is a GUI Git client for macOS and Windows aimed at making everyday
      Git workflows easier to reason about. It provides an interactive rebase
      editor, a built-in merge tool, side-by-side diffs, commit search, Git
      LFS locking support, and a CLI companion (`fork`) for opening
      repositories straight from the terminal.
    '';
    homepage = "https://fork.dev";
    downloadPage = "https://fork.dev";
    changelog = "https://fork.dev/releasenotes";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "danilpristupov";
        product = "fork";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "generic";
        spec = "danilpristupov/fork@${finalAttrs.version}?download_url=https://cdn.fork.dev/mac/Fork-${finalAttrs.version}.dmg";
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
