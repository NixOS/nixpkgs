{ lib
, pkgs
, symlinkJoin
, fetchzip
, melpaBuild
, stdenv
, fetchFromGitHub
, writeText
, melpaStablePackages
, runCommand
, tree-sitter-grammars
, plugins ? map (g: tree-sitter-grammars.${g}) (lib.importJSON ./default-grammars.json)
, final
}:

let
  inherit (melpaStablePackages) tree-sitter-langs;

  libSuffix = if stdenv.isDarwin then "dylib" else "so";
  soName = g: lib.removeSuffix "-grammar" (lib.removePrefix "tree-sitter-" g.pname) + "." + libSuffix;

  grammarDir = runCommand "emacs-tree-sitter-grammars" {
    # Fake same version number as upstream language bundle to prevent triggering runtime downloads
    inherit (tree-sitter-langs) version;
  } (''
    install -d $out/langs/bin
    echo -n $version > $out/langs/bin/BUNDLE-VERSION
  '' + lib.concatStringsSep "\n" (map (
    g: "ln -s ${g}/parser $out/langs/bin/${soName g}") plugins
  ));

in
melpaStablePackages.tree-sitter-langs.overrideAttrs(old: {
  postPatch = old.postPatch or "" + ''
    substituteInPlace ./tree-sitter-langs-build.el \
    --replace "tree-sitter-langs-grammar-dir tree-sitter-langs--dir"  "tree-sitter-langs-grammar-dir \"${grammarDir}/langs\""
  '';

  passthru = old.passthru or {} // {
    inherit plugins;
    withPlugins = fn: final.tree-sitter-langs.override { plugins = fn tree-sitter-grammars; };
  };

})
