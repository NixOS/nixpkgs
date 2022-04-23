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
}:

let

  inherit (melpaStablePackages) tree-sitter-langs;

  # Note: Commented grammars are in upstream bundle but missing from our packaged grammars
  grammars = [
    "agda"
    "bash"
    "c"
    "c-sharp"
    "cpp"
    "css"
    # "d"
    "elixir"
    "elm"
    "fluent"
    "go"
    "haskell"
    "hcl"
    "html"
    # "janet-simple"
    "java"
    "javascript"
    "jsdoc"
    "json"
    "julia"
    "nix"
    "ocaml"
    "ocaml-interface"
    # "pgn"
    "php"
    "prisma"
    "python"
    "ruby"
    "rust"
    "scala"
    "swift"
    "tsx"
    "typescript"
    "verilog"
    "zig"
  ];

  grammarDir = runCommand "emacs-tree-sitter-grammars" {
    # Fake same version number as upstream language bundle to prevent triggering downloads
    inherit (tree-sitter-langs) version;
  } (''
    install -d $out/langs/bin
    echo -n $version > $out/langs/bin/BUNDLE-VERSION
  '' + lib.concatStringsSep "\n" (map (g: "ln -s ${tree-sitter-grammars."tree-sitter-${g}"}/parser $out/langs/bin/${g}.so") grammars));

in
melpaStablePackages.tree-sitter-langs.overrideAttrs(old: {
  postPatch = old.postPatch or "" + ''
    substituteInPlace ./tree-sitter-langs-build.el \
    --replace "tree-sitter-langs-grammar-dir tree-sitter-langs--dir"  "tree-sitter-langs-grammar-dir \"${grammarDir}/langs\""
  '';
})
