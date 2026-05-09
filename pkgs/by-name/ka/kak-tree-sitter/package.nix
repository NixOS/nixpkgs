{
  lib,
  makeWrapper,
  fetchgit,
  callPackage,
  symlinkJoin,
  tinycc,
  kak-tree-sitter-unwrapped,
  bundledParsers ? [ ],
}:
let
  mkParserRaw = callPackage ./make-parser.nix { };
  parserSources = builtins.fromJSON (builtins.readFile ./parsers.json);
  mkParser' =
    lang:
    let
      getSrc =
        info:
        if info == null then
          null
        else
          fetchgit {
            inherit (info) url hash;
            rev = info.pin;
            fetchSubmodules = false;
          };
      grammarSrcInfo = parserSources.grammar.${lang} or null;
      queriesSrcInfo = parserSources.queries.${lang} or null;
      grammarSrc = getSrc grammarSrcInfo;
      queriesSrc = getSrc queriesSrcInfo;
    in
    mkParserRaw {
      inherit grammarSrc queriesSrc lang;
      grammarPin = parserSources.grammar.${lang}.pin or null;
      queriesPin = parserSources.queries.${lang}.pin or null;
    };
  mkParser = nameOrPkg: if builtins.isString nameOrPkg then mkParser' nameOrPkg else nameOrPkg;
  allParserNames' = lib.lists.uniqueStrings (
    (builtins.attrNames parserSources.grammar) ++ (builtins.attrNames parserSources.queries)
  );
  allParserNames = lib.lists.remove "astro" allParserNames'; # config broken
  allParsers = map mkParser allParserNames;
  requestedParsers = if bundledParsers == "all" then allParsers else map mkParser bundledParsers;

in
symlinkJoin (finalAttrs: {
  pname = lib.replaceStrings [ "-unwrapped" ] [ "" ] kak-tree-sitter-unwrapped.pname;
  inherit (kak-tree-sitter-unwrapped) version;
  name = "${finalAttrs.pname}-${finalAttrs.version}";

  paths = [ kak-tree-sitter-unwrapped ] ++ requestedParsers;
  nativeBuildInputs = [ makeWrapper ];

  # Tree-Sitter grammars are C programs that need to be compiled
  # Use tinycc as cc to reduce closure size
  postBuild =
    lib.optionalString (tinycc != null) ''
      mkdir -p $out/libexec/tinycc/bin
      ln -s ${lib.getExe tinycc} $out/libexec/tinycc/bin/cc
      wrapProgram "$out/bin/ktsctl" \
        --suffix PATH : $out/libexec/tinycc/bin
    ''
    + lib.optionalString (bundledParsers != [ ]) ''
      rm "$out/bin/kak-tree-sitter"
      cat >"$out/bin/kak-tree-sitter" <<EOF
      #!/usr/bin/env bash
      set -e
      shopt -s nullglob
      cfg="\''${XDG_DATA_HOME:-\$HOME/.local/share}/kak-tree-sitter"
      if [[ "\$(readlink "\$cfg/.state")" != "$out" ]]; then
        (cd $out/share/kak-tree-sitter; ls -d grammars/*/* queries/*/* 2>/dev/null | while read -r line; do
          mkdir -p "\$cfg/\''${line%/*}"
          ln -snf "\$PWD/\$line" "\$cfg/\$line"
        done)
        ln -snf "$out" "\$cfg/.state"
      fi
      exec "${lib.getBin kak-tree-sitter-unwrapped}/bin/kak-tree-sitter" "\$@"
      EOF
      chmod +x "$out/bin/kak-tree-sitter"
    '';

  passthru = {
    inherit mkParser;
    bundledParsers = requestedParsers;
  };

  __structuredAttrs = true;
  strictDeps = true;

  inherit (kak-tree-sitter-unwrapped) meta;
})
